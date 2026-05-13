import { execFileSync } from "node:child_process";
import path from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type GitCounts = {
	staged: number;
	unstaged: number;
	untracked: number;
};

type GitStatus = GitCounts & {
	branch: string;
	worktree?: string;
};

function gitOutput(cwd: string, args: string[]): string | undefined {
	try {
		return execFileSync("git", args, {
			cwd,
			encoding: "utf8",
			stdio: ["ignore", "pipe", "ignore"],
			timeout: 1000,
		});
	} catch {
		return undefined;
	}
}

function git(cwd: string, args: string[]): string | undefined {
	return gitOutput(cwd, args)?.trim();
}

function absoluteGitPath(cwd: string, gitPath: string): string {
	return path.resolve(cwd, gitPath);
}

function getBranch(cwd: string): string | undefined {
	const branch = git(cwd, ["branch", "--show-current"]);
	if (branch) return branch;

	const commit = git(cwd, ["rev-parse", "--short", "HEAD"]);
	return commit ? `detached:${commit}` : undefined;
}

function getWorktree(cwd: string, root: string): string | undefined {
	const gitDir = git(cwd, ["rev-parse", "--git-dir"]);
	const commonDir = git(cwd, ["rev-parse", "--git-common-dir"]);
	if (!gitDir || !commonDir) return undefined;

	const absoluteGitDir = absoluteGitPath(cwd, gitDir);
	const absoluteCommonDir = absoluteGitPath(cwd, commonDir);
	if (absoluteGitDir === absoluteCommonDir) return undefined;
	if (!absoluteGitDir.includes(`${path.sep}worktrees${path.sep}`)) return undefined;

	return path.basename(root);
}

function getCounts(cwd: string): GitCounts {
	const output = gitOutput(cwd, ["status", "--porcelain=v1", "--untracked-files=all"]);
	const counts = { staged: 0, unstaged: 0, untracked: 0 };
	if (!output) return counts;

	for (const line of output.trimEnd().split("\n")) {
		const indexStatus = line[0];
		const worktreeStatus = line[1];

		if (indexStatus === "?" && worktreeStatus === "?") {
			counts.untracked++;
			continue;
		}

		if (indexStatus && indexStatus !== " ") counts.staged++;
		if (worktreeStatus && worktreeStatus !== " ") counts.unstaged++;
	}

	return counts;
}

function getGitStatus(cwd: string): GitStatus | undefined {
	if (git(cwd, ["rev-parse", "--is-inside-work-tree"]) !== "true") return undefined;

	const root = git(cwd, ["rev-parse", "--show-toplevel"]);
	const branch = getBranch(cwd);
	if (!root || !branch) return undefined;

	return {
		branch,
		worktree: getWorktree(cwd, root),
		...getCounts(cwd),
	};
}

function renderStatus(ctx: ExtensionContext, status: GitStatus): string {
	const theme = ctx.ui.theme;
	const dirty = status.staged + status.unstaged + status.untracked > 0;
	const parts = [
		theme.fg("accent", ` ${status.branch}`),
		status.worktree ? theme.fg("muted", `🌳 ${status.worktree}`) : undefined,
		dirty ? theme.fg("warning", "✗ dirty") : theme.fg("success", "✓ clean"),
		theme.fg(status.staged > 0 ? "success" : "dim", `+${status.staged} staged`),
		theme.fg(status.unstaged > 0 ? "warning" : "dim", `~${status.unstaged} unstaged`),
		theme.fg(status.untracked > 0 ? "error" : "dim", `?${status.untracked} untracked`),
	];

	return parts.filter(Boolean).join(theme.fg("dim", "  "));
}

function updateGitStatus(ctx: ExtensionContext) {
	if (!ctx.hasUI) return;

	const status = getGitStatus(ctx.cwd);
	ctx.ui.setStatus("git-status", status ? renderStatus(ctx, status) : undefined);
}

export default function (pi: ExtensionAPI) {
	let timer: ReturnType<typeof setInterval> | undefined;
	let lastCtx: ExtensionContext | undefined;

	function start(ctx: ExtensionContext) {
		lastCtx = ctx;
		updateGitStatus(ctx);
		if (timer) clearInterval(timer);
		timer = setInterval(() => {
			if (lastCtx) updateGitStatus(lastCtx);
		}, 5000);
		timer.unref?.();
	}

	pi.on("session_start", async (_event, ctx) => {
		start(ctx);
	});

	pi.on("tool_execution_end", async (_event, ctx) => {
		lastCtx = ctx;
		updateGitStatus(ctx);
	});

	pi.on("turn_end", async (_event, ctx) => {
		lastCtx = ctx;
		updateGitStatus(ctx);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		if (timer) clearInterval(timer);
		timer = undefined;
		ctx.ui.setStatus("git-status", undefined);
	});
}

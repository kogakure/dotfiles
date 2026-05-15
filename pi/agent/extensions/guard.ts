import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const DENY_PATTERNS: Array<[RegExp, string]> = [
  [/\brm\s+(-[rRf]+\s+)?(\/|~|\$HOME|\.\.)/, "destructive rm on protected path"],
  [/\bsudo\b/, "privilege escalation"],
  [/\b(curl|wget)\s+.*\|\s*(ba)?sh/, "curl-pipe-to-shell"],
  [/\bgit\s+push.*(--force|--mirror).*(main|master|production)/, "force-push to protected branch"],
  [/\bchmod\s+777/, "world-writable chmod"],
  [/\bdd\s+.*of=\/dev\//, "raw disk write"],
  [/\bmkfs\b/, "filesystem format"],
];

const DENY_PATHS = [
  /\.env(\.|$)/,
  /~\/\.ssh/,
  /~\/\.aws/,
  /~\/\.gnupg/,
  /id_rsa/,
  /\/etc\/(passwd|shadow)/,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    const cmd = event.input?.command ?? event.input?.file_path ?? event.input?.path ?? "";

    if (event.toolName === "bash") {
      for (const [re, reason] of DENY_PATTERNS) {
        if (re.test(cmd)) {
          ctx.ui.notify(`BLOCKED: ${reason}`, "error");
          return { block: true, reason: `Guard blocked: ${reason}` };
        }
      }
    }

    if (["read", "write", "edit"].includes(event.toolName)) {
      for (const re of DENY_PATHS) {
        if (re.test(cmd)) {
          ctx.ui.notify(`BLOCKED: protected path ${cmd}`, "error");
          return { block: true, reason: `Guard blocked: protected path` };
        }
      }
    }
  });
}

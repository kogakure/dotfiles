# Commands

## Justfile — the entry point

`just` wraps the scripts below so you do not have to remember which one to
run. It works from any cwd. Full reference: [guardrails.md](guardrails.md).

```bash
just                  # list every recipe
just setup *ARGS      # ./setup.sh; `just setup --only link,gnupg`
just setup-dry        # ./setup.sh --dry-run
just setup-steps      # ./setup.sh --list
just link             # ./install
just check-links      # ./install --dry-run
just update           # bin/update
just generate         # bin/generate-shell-config; rebuild from shell/*.spec
just lint             # shellcheck, shfmt, fish/zsh syntax, POSIX source, yaml, unit, manifest, drift
just fmt              # shfmt -w over every shell source
just backup *ARGS     # every backup; `just backup --dry-run`, `just backup preferences`
just doctor *ARGS     # read-only health check; `just doctor --verbose`
just clean *ARGS      # remove dangling links and dead tmux plugins; --apply to act
just install-hooks    # enable the pre-commit hook
```

## Initial Setup

`setup.sh` is a **step registry**, not a straight line. Every action is a
`step_<name>` function, the ordered list is `ALL_STEPS` at the top of the file,
and each step runs through `run_step` — so one failure is reported by name in a
summary rather than aborting the run, and a re-run resumes instead of redoing an
hour of `brew bundle`.

```bash
./setup.sh                        # every step, in order
./setup.sh --dry-run              # print every mutation, change nothing
./setup.sh --list                 # the ordered step list
./setup.sh --only link,gnupg      # just these
./setup.sh --skip macos,services  # everything but these
./setup.sh --from editors         # that step and everything after it
./setup.sh --force                # ignore the state file
./setup.sh --no-interactive       # skip the steps that prompt
./setup.sh --help
```

The steps, in order:

```
preflight  submodules  directories  homebrew  packages  link  terminfo
tmux_plugins  extensions  shell_default  gnupg  runtimes  editors  projects
macos  services  interactive
```

Four things about that order are load-bearing:

- **`link` runs after `packages`.** `./install` execs dotbot, and dotbot is a
  brew formula — so it only exists once `brew bundle` has run. The old order
  called it nineteen lines earlier, which worked on every machine that already
  had it and on no fresh one. `packages` supplies `fish` for the same reason.
- **`preflight` stops the run when it fails**, rather than being recorded and
  continued past. The steps after it fail as consequences of one cause; a
  hostname with no Brewfile aborts `brew bundle` and then nine steps fail for
  want of their binaries. `--skip preflight` overrides.
- **`interactive` is last and gated.** `atuin login` and `doom install` are the
  only things that block on a prompt, and they used to sit mid-script with ten
  steps after them. Interactive mode is on only when stdin is a TTY, so
  `./setup.sh </dev/null` completes without stopping.
- **`macos` restores preferences before applying settings.** Deliberate — see
  the comment on `step_macos`.

**Resume.** Completed steps are recorded one per line in
`${XDG_STATE_HOME:-~/.local/state}/dotfiles/setup-state`. The file only grows on
success, so a resumed run retries exactly what failed. `preflight` and
`interactive` are never recorded: a precondition that can be resumed past is one
that passes on the strength of having once passed, and `interactive` reports
success when it skipped itself for want of a terminal.

**`--dry-run` is inert, not nominal.** It changes nothing, never prompts for a
password, and writes no state file. CI asserts all three.

**Which steps are safe to `--only`.** The re-runnable ones: `link`, `packages`,
`tmux_plugins`, `extensions`, `runtimes`, `editors`. Not `shell_default`,
`macos` or `interactive`, which change the login shell, overwrite preferences,
or prompt.

`packages` joined that list in SI-119. It was excluded because
`bin/homebrew-restore` ran `brew bundle cleanup --force` on every invocation,
which uninstalls anything absent from the Brewfile; it now installs only.

## Shell configuration — generated, not hand-written

```bash
bin/generate-shell-config              # rebuild from shell/*.spec
bin/generate-shell-config --dry-run    # print what it would write
just generate                          # the same, from any cwd
```

Environment, `PATH`, aliases and tool hooks are described **once** in
`shell/*.spec` and emitted for bash, zsh, fish and nushell. The output is
committed, so no shell startup depends on this script.

Workflow: edit a spec → `just generate` → commit both. `just lint drift`
regenerates and fails if the committed output does not match, so a spec edit
that was never regenerated cannot ship.

**Never hand-edit anything under `generated/`, `config/fish/conf.d/0*.fish` or
`config/nushell/env.nu`.** Each carries a `DO NOT EDIT` header, and the next
`just lint` will overwrite it.

`shell/README.md` documents the syntax. See
[environment.md](environment.md) for the load order and
[guardrails.md](guardrails.md) for the drift gate.

## Symlink Management

```bash
./install              # Re-run dotbot to update symlinks
./install --dry-run    # Show what it would do, without touching anything
```

`./install` is **required** after anything that changes a link target — in
particular after pulling the SI-84 shell-config cutover, which repoints
`~/.aliases` and `~/.session-variables.sh` at `generated/` and adds
`~/.hooks.{bash,zsh,fish}`. Until it runs, those two point at deleted files and
every bash and zsh start reports a missing source.

## Linting

```bash
bin/dotfiles-lint                 # every check
bin/dotfiles-lint posix yaml      # a subset, by name
bin/dotfiles-lint --staged        # staged files only (what the hook runs)
bin/dotfiles-lint --strict        # a missing linter is an error (what CI runs)
bin/dotfiles-lint --snapshot      # re-snapshot .lint-baseline
bin/dotfiles-lint --help
```

## Homebrew

```bash
./bin/homebrew-backup           # Save this machine's packages to homebrew/<host>
./bin/homebrew-restore          # Report what is missing, then install it
./bin/homebrew-restore --prune  # Also offer to uninstall what the file omits
```

Both take `--dry-run`.

**`homebrew/<host>` is `brew bundle dump` output — never hand-edit it.**
`bin/homebrew-backup` rewrites the file whole, and `bin/update` calls it on
every run, so anything you type into one survives until the next update on that
machine and no longer. A package is in the file if and only if it is
**installed on request** there; the fix for a missing line is `brew install
<name>` on the host, not an edit here. The warning lives in the docs rather
than in a file header for the same reason: `--force` rewrites the whole file,
so a header comment would not survive either. See
[architecture.md](architecture.md) for the consequences, including why a
formula deliberately deleted from a dump comes back.

**`homebrew-restore` cannot uninstall anything without `--prune`.** Until
SI-119 it ran `brew bundle cleanup --force` on every invocation, which removes
every formula and cask the Brewfile does not name — 368 formulae and 121 casks
on `macbook-m5-pro`, unattended, with no `brew` undo. `--prune` now lists what
would go and asks first.

Two things about that prompt are deliberate. `--prune` is read from the command
line only and never from `$DOTFILES_PRUNE`, so no aggregator can turn it on for
you. And the confirmation ignores `--yes`, against the convention every other
prompt in this repository follows — `confirm` answers *no* when there is no
terminal, so cron, `ssh host cmd` and any nested call are safe by construction.

### Which Brewfile, and what happens when there is no match

The file is `homebrew/$(hostname -s)`. `$DOTFILES_HOST` overrides it:

```bash
DOTFILES_HOST=mac-mini ./bin/homebrew-restore --dry-run
```

A host with no Brewfile is a **hard failure** that names the hosts that do have
one, plus both fixes. It used to be a silent skip of the longest step in
`setup.sh`. That matters more than it sounds: on macOS `hostname` returns the
Bonjour name, which changes with the network (`.local`, `.fritz.box`), and a
fresh Mac reports something like `Mac.local`. `sudo scutil --set HostName` is
the permanent fix; `DOTFILES_HOST` is for a one-off run.

### Reporting drift without touching anything

```bash
brew bundle check --no-upgrade --verbose --file homebrew/<host>
```

**`--no-upgrade` is load-bearing.** Without it, `brew bundle check` reports
every *outdated* package as "needs to be installed or updated" — 40+ lines on
`macbook-m5-pro`, including `mise`, which is plainly installed. That is
indistinguishable from real drift, so the check gets ignored. With the flag, the
output is what is genuinely absent.

`bin/dotfiles-doctor` runs this for you (SI-85).

## `packages/` — the shared plugin and service lists

Plain-text lists, one entry per line, `#` comments ignored. `setup.sh` installs
from them and `bin/update` updates from them, so there is one definition instead
of two that drift.

| File | Holds |
| --- | --- |
| `packages/gh-extensions` | `owner/repo` per gh extension |
| `packages/herdr-plugins` | `owner/repo` per herdr plugin |
| `packages/services` | one brew formula per service to start |
| `config/fish/fish_plugins` | fisher's own file, reused rather than copied |

**At the repository root, never under `config/`.** `install.conf.yaml` globs
`config/*` into `~/.config/`, so anything put there is symlinked into the live
tree as a side effect.

Adding an entry is one line. `just lint unit` asserts each file parses to at
least one entry and lists nothing twice.

These files exist because the lists were inline in `setup.sh` while `bin/update`
needed the same ones and `docs/environment.md` kept a third copy in prose. All
three disagreed: `gh-stack` was installed and named nowhere, `gh-copilot` was
documented and never installed, and one of three herdr plugins was missing from
the install list.

`packages/services` is also a bug fix. The two lines it replaced were
unconditional `brew services start atuin` / `... borders`, but `atuin` is
mise-managed on `macbook-m5-pro` and `borders` is only in `macbook-2019`'s
Brewfile — so both failed here and one failed on `mac-mini`. Second-to-last,
under `set -e`, which is why `Setup complete.` was unreachable on two of three
machines. Each service is now started only if brew has the formula.

## System Updates

```bash
./bin/update  # Update all components:
              # - Homebrew packages
              # - mise tools (`mise upgrade`: an exact pin in
              #   config/mise/mise.toml does not move, a "latest" entry does)
              # - Rust toolchain (`rustup update`; rustup owns it, not mise)
              # - Ruby gems
              # - tmux plugins (via tpm)
              # - GitHub CLI extensions
              # - herdr plugins (re-installed from packages/herdr-plugins —
              #   herdr has no `plugin update`, so re-install is the update)
              # - Fish plugins (via fisher)
              # - Neovim plugins (via Lazy)
              # - macOS software
              # - Runs bin/dotfiles-backup (Claude, Codex, Homebrew,
              #   preferences, launch agents), isolating each step's failure
              #   and naming it in the summary
```

## Backup/Restore

`bin/dotfiles-backup` is the aggregator. It runs every backup, isolates their
failures from each other, and exits non-zero naming the ones that failed —
which is what `bin/update` calls.

```bash
./bin/dotfiles-backup                    # claude, codex, homebrew, preferences, launch-agents
./bin/dotfiles-backup --dry-run          # print the whole plan, change nothing
./bin/dotfiles-backup preferences        # one named step
./bin/dotfiles-backup --gpg              # include the GPG export (see below)
./bin/dotfiles-backup --help
```

Every backup and restore script takes `--dry-run`, and every one that prompts
takes `--yes`. Flags also travel through the environment, so a sub-script
invoked directly honours what the aggregator set:

| Variable | Effect |
| --- | --- |
| `DOTFILES_DRY_RUN=1` | print mutations instead of applying them |
| `DOTFILES_ASSUME_YES=1` | answer prompts with yes |
| `DOTFILES_ALLOW_DIRTY=1` | run even though `private/` has uncommitted changes |
| `DOTFILES_PRUNE=1` | allow deletion of backup entries (nothing wires this yet) |
| `DOTFILES_REQUIRE_CLEAN_PRIVATE=1` | make a clean `private/` a hard precondition |

The individual entry points:

```bash
./bin/agentic-set-profile work|personal  # Select the shared Claude/Codex profile
./bin/claude-backup           # Save Claude Code config to private/claude/<profile>
./bin/claude-restore          # Restore Claude Code config for the current profile
./bin/codex-backup            # Save Codex config to private/codex/<profile>
./bin/codex-restore           # Restore Codex config for the current profile
./bin/codex-restore personal  # Bootstrap another profile from the personal backup
./bin/preferences-backup      # Export app preferences
./bin/preferences-restore     # Import app preferences
./bin/gpg-keys-backup         # Export GPG keys — opt-in, see below
./bin/gpg-keys-restore        # Import GPG keys
```

**Adding an app to the preferences backup is one line.** The table lives in
`bin/lib/preferences.manifest`; the two scripts just walk it. `just lint
manifest` asserts every file in `private/preferences/` is either listed there
or recorded as deliberately manual.

**GPG is opt-in.** `bin/gpg-keys-backup` writes an armoured *secret* key to
disk and can block on a pinentry prompt, so it is not part of a routine
`just update`; pass `--gpg` to include it. It is named as skipped in every
summary so it cannot be forgotten.

**Pruning is off.** No backup deletes a destination whose source is missing,
because `private/<agent>/<profile>/` is shared between machines: two hosts on
the same profile would delete each other's content. See
[guardrails.md](guardrails.md).

**Launch agents: the backup is automated, `launchctl` is not.**
`bin/dotfiles-backup`'s `launch-agents` step refreshes the plists already
tracked in `private/launch-agents/` from `~/Library/LaunchAgents/`. It is
deliberately a whitelist and never adopts a new agent, because that directory is
full of Dropbox, Google and Steam updaters. Installing an agent on a new machine
is still a manual `launchctl bootstrap`.

(The old `bin/launchagents-backup` and `bin/launchagents-restore` were empty
stubs — a shebang and nothing else — that `setup.sh` and `bin/update` called
while these docs claimed they worked. SI-81 deleted them rather than leave
silent no-ops; SI-82 implemented the half that can be verified without a fresh
machine.)

## Health checks — `doctor` and `clean`

```bash
just doctor                    # every check, read-only
just doctor --verbose          # with the evidence behind each finding
just doctor brewfile mise      # a subset, by name
just clean                     # print a removal plan, change nothing
just clean --apply             # remove, asking first
just clean --apply --yes       # remove without asking
```

`bin/dotfiles-doctor` reports; `bin/dotfiles-clean` repairs. They are two
scripts rather than one with a `--fix` flag so that the reporting half can be
**provably** read-only: it calls `run` nowhere, its only write is the shell-config
generator into a `mktemp` directory, and `just lint unit` plus CI both hold it to
that. A tool you are willing to run on a machine you do not understand has to be
one that cannot make things worse.

Doctor's checks:

| Check | Answers |
| --- | --- |
| `links` | are there dangling symlinks, and did every dotbot link actually land? |
| `brewfile` | is the host Brewfile satisfied, and do the three hosts agree? |
| `packages` | is the tool behind each `config/` entry installed here? |
| `binaries` | does every command `config/git/config` names resolve? |
| `mise` | one config — counting `.tool-versions`, not just `.toml` — every tool resolving from outside the repo, no double provision |
| `runtimes` | how many things provide `node`? |
| `shells` | is `fish` in `/etc/shells` exactly once? |
| `generated` | is the committed shell config current? |
| `plugins` | are the declared tmux plugins installed? |
| `submodule` | is `private/` initialised and clean? |

**It exits non-zero when it finds anything**, so it can gate a script. It is
loud the first time, and that output is the backlog rather than a bug.

`packages` and `binaries` read `bin/lib/config-owners.manifest`, which is what
makes them cover mise tools and gh extensions rather than only formulae. Adding
a directory under `config/` fails `just lint owners` until that file says what
installs the tool — see [architecture.md](architecture.md).

### `clean` is dry-run by **default**, which inverts the usual convention

Everywhere else in this repository `--dry-run` is opt-in, because everywhere
else the default is to copy a file or install a package. This script's whole job
is deletion, so the safe direction is the other one: `just clean` prints a plan,
and `--apply` is required to act. `--apply` is read from the command line only,
so nothing can turn deletion on through the `DOTFILES_*` environment channel.

It removes exactly two things, both demonstrably dead — dangling symlinks under
the four directories `install.conf.yaml` cleans, and `~/.tmux/plugins` entries
`tmux.conf` no longer names. Everything else it finds it **reports and leaves
alone**: those artefacts are dead on the evidence of reading them rather than of
a check, and that belongs in a commit someone reviews.

## macOS Settings

```bash
./bin/macos-settings  # Apply macOS system preferences
```

## AI Sandboxes

```bash
sbxa pi [PATH...] [--name NAME] [sbx create flags] [-- PI_ARGS...]
  # Herdr-aware launcher (config/fish/functions/sbxa.fish) for the Pi coding
  # agent (https://github.com/badlogic/pi-mono) in a Docker Sandboxes (sbx)
  # container, via the custom "pi" sandbox kit at config/sbx/kits/pi (sbx has
  # no built-in pi agent). Seeds the sandbox with the host's ~/.pi/agent
  # config (auth, settings, extensions, skills, themes) on first launch.
  # Also works for built-in sbx agents, e.g. `sbxa claude`.
  # See config/sbx/kits/pi/README.md for details.

./bin/sbx-pi ...  # what sbxa pi delegates to; same usage, callable directly

sbxa omp [PATH...] [--name NAME] [sbx create flags] [-- OMP_ARGS...]
  # Same pattern for omp (https://omp.sh, a batteries-included pi-mono fork),
  # via config/sbx/kits/omp. Seeds the sandbox with the host's ~/.omp/agent
  # OAuth logins and model-role config. See config/sbx/kits/omp/README.md.

./bin/sbx-omp ...  # what sbxa omp delegates to; same usage, callable directly

sbxa claude [PATH...] [--name NAME] [sbx create flags] [-- CLAUDE_ARGS...]
  # Uses sbx's built-in "claude" agent (no kit), but adds the cship statusline
  # so the sandboxed TUI looks like the host one: the linux-musl cship and
  # starship builds are cached under ~/.cache/sbx-statusline, pushed in with
  # `sbx cp`, and enabled via `claude --settings` (the container's
  # ~/.claude/settings.json is rewritten by sbx on every create, so editing it
  # would not stick). SBX_CLAUDE_REFRESH=1 re-downloads the cached binaries.

./bin/sbx-claude ...  # what sbxa claude delegates to; same usage, callable directly
```

Every `sbxa` launch mounts `~/Downloads` read-only, so images and files dropped there
are readable by the agent without passing the path. Pass `~/Downloads` explicitly to
override the mode. Workspace mounts are only applied when the sandbox is **created** —
`sbx rm <name>` first to add the mount to a sandbox that already exists.

## Worktrees

```bash
./bin/node-install [directory]  # Detect npm/yarn/pnpm (packageManager field, then
                                 # lockfile, then npm) and run its install command.
                                 # No-op (exit 0) if there's no package.json.
```

The `tdi.worktree-setup` herdr plugin runs `bin/node-install` automatically whenever
`herdr worktree create`/`open` creates a new git worktree, via herdr's `worktree.created`
event hook. Its config lives at
`config/herdr/plugins/config/tdi.worktree-setup/config.toml` — add a `[[project]]` entry
there for repo-specific setup steps (e.g. copying `.env` files). See that file for the
format and available `$HERDR_*` environment variables.

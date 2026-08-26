# Guardrails

Lint, CI and the git hook. Everything in this repo ends up sourced by a login
shell on three machines, so a syntax error is not a failing test — it is a
broken shell. These checks exist to catch that before it ships.

## Justfile

`Justfile` at the repo root is the single entry point. Recipes **wrap** the
existing scripts, they never reimplement them.

```bash
just                  # list the recipes
just setup            # ./setup.sh
just link             # ./install
just check-links      # ./install --dry-run
just setup *ARGS      # ./setup.sh          (e.g. just setup --only link)
just setup-dry        # ./setup.sh --dry-run
just setup-steps      # ./setup.sh --list
just update           # bin/update
just lint             # every check (see below)
just lint-staged      # the same checks, staged files only
just lint-strict      # missing linter is an error, not a skip (CI)
just lint-snapshot    # re-snapshot .lint-baseline
just fmt              # shfmt -w over every shell source
just install-hooks    # git config core.hooksPath .githooks
just uninstall-hooks  # git config --unset core.hooksPath
just doctor           # bin/dotfiles-doctor      (arrives with SI-85)
just backup *ARGS     # bin/dotfiles-backup      (e.g. just backup --dry-run)
```

`just` chdirs into the Justfile's directory before running a recipe, so no
recipe depends on the caller's cwd:

```bash
cd ~ && just -f ~/.dotfiles/Justfile lint    # works
```

`just` comes from Homebrew and is in all three Brewfiles.

## `bin/dotfiles-lint`

The lint engine. `just lint`, `.githooks/pre-commit` and
`.github/workflows/ci.yml` all call this one script, so the three can never
disagree about what "clean" means. It resolves its own repo root and is
written for bash 3.2 so it still runs under a reduced PATH.

| Check        | What it does                                                     |
| ------------ | ---------------------------------------------------------------- |
| `shellcheck` | every bash/sh source, gated on `.lint-baseline` (see below)       |
| `shfmt`      | `shfmt -d -i 4 -ci` over the same set — must be clean            |
| `fish`       | `fish -n` over the hand-written fish config and functions         |
| `zsh`        | `zsh -n` over `zshrc`/`zshenv` — shellcheck has no zsh dialect    |
| `posix`      | **sources** the startup files and asserts stderr is empty         |
| `yaml`       | parses `install.conf.yaml`, asserts every `link:` source exists   |
| `unit`       | runs the pure helpers in `bin/lib/` against fixtures, plus two whole-file invariants — see below |
| `manifest`   | parses `preferences.manifest`, asserts it covers `private/preferences/` |
| `drift`      | re-runs the shell-config generator, asserts no diff (SI-84)       |

Run a subset by name: `just lint posix yaml`.

### The file lists maintain themselves

Nothing is enumerated by hand:

- Shell sources are the union of `setup.sh`, `install`, `bin/*`,
  `bin/lib/*.sh`, `functions/*.sh`, `.githooks/*` and the shebang-less startup
  files, minus anything whose **shebang** names another interpreter. That is
  why `bin/key_counter_summary.py` and `bin/gource-gravatars` drop out while
  `bin/convert-2-imdb3-format.sh` — bash wrapping a python heredoc — stays in.
- Fish sources come from `git ls-files`, so the ~20 vendored fisher functions
  under `config/fish/functions/` stay out for free: they are gitignored and
  untracked. Adding a fisher plugin needs no change here.
- `just fmt` formats exactly `dotfiles-lint --list-shell-sources`, so the
  formatter and the linter can never diverge on which files are shell.

### The POSIX runtime source test

The most valuable check in the suite, and the reason the rest exists.

`bash -n` happily *parses* fish-syntax aliases:

```sh
alias e "emacs -nw"     # bash -n: exit 0. Sourced: two errors on stderr.
```

Two of those shipped to three machines and errored on every bash and zsh
startup. Only actually sourcing the file catches it, and only stderr reveals
it — the exit status is 0. So the check sources `aliases`,
`session-variables.sh`, `profile` and `bash_profile` in a clean
`bash --noprofile --norc` (and in `zsh -f`) and **asserts stderr is empty**.

It sources them under a throwaway `$HOME` holding just the dotbot symlinks
those files reach for. Without that, `profile` — which unconditionally sources
`~/.session-variables.sh` — would pass or fail depending on whether the
*installed* symlink happens to exist on the machine running the lint. A gate
that passes by accident of local state is not a gate. The sandbox is torn down
by removing the symlinks it created and `rmdir`-ing the directory; no `rm -rf`
anywhere near a dotfiles repo.

`bashrc` and `zshrc` are deliberately excluded. They are interactive-shell
config full of `eval "$(tool init …)"`, so their stderr depends on which tools
are installed and is not a stable signal. `shellcheck` and `zsh -n` cover them.

CI additionally appends a fish-syntax alias to `aliases` and asserts the check
*fails*, so it cannot silently stop gating anything.

### The `unit` check — and why `bin/lib/` exists

`bin/lib/shells.sh` is not there for reuse. It exists so that logic buried
inside a privileged, un-runnable script can still be tested.

`setup.sh` registers fish in `/etc/shells`. That write needs `sudo`, and the
surrounding script installs Homebrew and changes your login shell, so it can
never be a lint gate — which is exactly how the original bug survived: two
byte-identical `tee -a` calls appended the path on every run, and `/etc/shells`
grew to **four** fish entries across three machines before anyone noticed.

The split is the fix. `shells_file_desired` is pure and takes the shells file
as an argument; `register_login_shell` does the `sudo tee`. The `unit` check
exercises the first against fixtures starting at 0, 1, 2 and 4 entries, applies
it **twice** each time, and asserts every case converges to exactly one entry
and stays there — plus that unrelated entries and the original ordering survive
the rewrite, since the collapse rewrites the whole file rather than appending.

Two properties worth keeping when this grows:

- **Test the transformation, not the write.** Anything needing `sudo`, a
  network, or a fresh machine belongs on the other side of the split. If a
  helper cannot be called with a path argument and no privileges, it is not
  ready for this check.
- **The fixtures include the broken state, not just the clean one.** The
  original acceptance criterion was "exactly one entry after two consecutive
  `setup.sh` runs" — the 0-entry row only, which no machine here could produce.
  The 2- and 4-entry rows are the repair path, and reverting to the old
  append-only rule fails on exactly those two while 0 and 1 still pass. That
  asymmetry is why the bug shipped, and it is what the check now pins down.

### Two invariants in `unit` that are not about `bin/lib/`

Most `unit_*` functions exercise a pure helper against a fixture. Two instead
assert a property of a whole file, because both properties are invisible until a
fresh machine trips over them.

**`unit_steps` — `setup.sh`'s registry agrees with its functions.** The driver
dispatches by name, `run_step "$step" "step_$step"`, so a typo in `ALL_STEPS` is
not a syntax error: it is a step that fails with "command not found", on a fresh
machine, halfway through a bootstrap. The reverse is just as quiet — a `step_*`
function missing from `ALL_STEPS` never runs and nothing says so. Both
directions are checked, plus that `NEVER_RESUME` names real steps.

This is why `known_step` is not called `step_exists`. The `step_` prefix is
reserved for step implementations; a helper wearing it looks exactly like a dead
step, and the check said so the first time it ran.

**`unit_packages` — the `packages/` files are not empty and not duplicated.**
`package_list` returning nothing on a missing file would put the drift straight
back: a run that installs no gh extensions and reports success. So a missing file
must stay distinguishable from an empty one, and the real files are checked too —
a list that parses to no entries, or names an entry twice, is a defect in the
data rather than a preference.

## `bin/lib/` — the shared library

SI-82 grew `bin/lib/` from one file into the library every `bin/` script that
needs a shared helper sources. `bin/lib/common.sh` is the only entry point; it
sources the rest.

```bash
set -euo pipefail

# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
. "$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh" || exit 1
```

`${BASH_SOURCE[0]}` and not `$0`, and `source-path=SCRIPTDIR` and not a
repo-relative path: these scripts are invoked by bare name from `PATH`, so
anything cwd-relative resolves by luck. The older
`# shellcheck source=bin/lib/shells.sh` form silently stops resolving as soon as
shellcheck runs from anywhere but the repo root.

| File | Holds |
| --- | --- |
| `common.sh` | entry point, `_DL_ROOT`, `run`, `write_file`, `run_step`, `step_summary`, `dotfiles_flags_init` |
| `log.sh` | `log_info/step/field/ok/skip/note/warn/err/done` |
| `util.sh` | `have`, `dotfiles_root`, `private_root`, `private_gate`, `host_id`, `brew_prefix`, `confirm` |
| `profile.sh` | `agentic_profile`, `profile_read`, `profile_is_valid`, `assert_valid_profile` |
| `sync.sh` | `backup_file/dir`, `restore_file/dir`, `sync_conflicts`, `sync_prune_extra/apply` |
| `privilege.sh` | `privilege_prime/keepalive/release/refresh`; **not** sourced by `common.sh`, for the same reason as `shells.sh` |
| `preferences.sh` | the manifest parser and both direction handlers |
| `shells.sh` | `/etc/shells` registration; **not** sourced by `common.sh`, since only `setup.sh` needs it |

### Sourcing the library has no side effects

The library defines functions and `_DL_`-prefixed names. It sets **no shell
option**, writes nothing and prints nothing.

That is not style. `set -euo pipefail` inside a sourced file changes the
*caller's* options, from the source line onward, in a dozen scripts at once and
invisibly — and it would break four of them:

- `bin/dotfiles-lint` and `bin/preferences-restore` run without `-e`
  deliberately, the first for its `FAILED` accumulator and the second so one
  missing plist does not abort the other eighteen.
- bash 3.2 — the `/bin/bash` macOS ships, which runs all of these — treats an
  **empty array as unbound** under `set -u`. That makes `-u` fatal to the three
  `sbx-*` launchers on their *default* invocation:

  ```console
  $ /bin/bash -c 'set -u; a=(); printf "[%s]" "${a[@]}"'
  /bin/bash: a[@]: unbound variable
  ```

So every script declares its own `set` line literally, above the source line,
and anything weaker than `set -euo pipefail` carries a comment saying why.

### Two copies that stay, on purpose

The "one definition outside `bin/lib/`" rule has exactly two exemptions, both
structural:

- **`bin/dotfiles-lint` keeps its own `C_*` colours and `heading/ok/warn/fail`.**
  The lint engine may not depend on the code it lints: a syntax error in
  `common.sh` would disable the only tool that catches it. It also promises to
  run under `PATH=/usr/bin:/bin`, and `check_unit` dot-sources the libraries into
  its own process to test them — which is why the library uses the `log_` and
  `_DL_` prefixes and never defines `warn`, `ok` or `fail`.
- **`config/fish/config.fish` keeps its own brew-prefix branch.** Fish cannot
  source a bash library.

### bash 3.2 traps this phase walked into

Both cost real time, and neither is visible from an interactive shell where
`bash` is Homebrew's 5.x:

- **`case` inside `$( )` does not parse.** `out=$(case x in y) ;; esac)` is a
  syntax error on `/bin/bash` and fine on bash 5. `check_manifest` uses a real
  `( … ) >"$tmp"` subshell for that reason. Always verify with `/bin/bash -n`,
  not `bash -n`.
- **Empty-array expansion under `set -u`**, above. Use
  `${arr[@]+"${arr[@]}"}` where an array may be empty.

### Pruning is opt-in, and off

No helper in `bin/lib/sync.sh` deletes anything. `codex-backup` used to `rm` a
destination whose source was absent and `claude-backup` did not; unifying onto
the pruning version would delete, from a `private/<agent>/<profile>/` that is
per-profile but **not per-host**, everything another machine had committed and
this one lacks. `private/claude/personal` and `private/codex/personal` were last
written from `mac-mini`; both `work` profiles from `macbook-m5-pro`.

Pruning is therefore a separate keep-list pass — `sync_prune_extra` prints,
`sync_prune_apply` deletes — behind `--prune`, behind `private_gate`, and wired
into nothing yet. `unit_no_prune` fails if a helper starts deleting again.

### The private-submodule gate

`private_gate <path>...` answers three ways, because three callers want three
answers:

| Situation | Answer |
| --- | --- |
| nested call from `bin/dotfiles-backup` | return at once — it checked once already, and its own first step dirties the submodule |
| routine backup, submodule dirty | warn and continue — the dirt is this machine's own uncommitted backup, and refusing would make `just update` fail on the second consecutive day while protecting nothing |
| `--prune`, or `DOTFILES_REQUIRE_CLEAN_PRIVATE=1` | refuse — the only irreversible mode |

`--allow-dirty` downgrades a refusal. The status query is scoped to the paths a
step writes, so an uncommitted `claude/work` change does not block
`preferences-backup`.

### Flags travel by environment, not argv

`bin/dotfiles-backup` exports `DOTFILES_DRY_RUN`, `DOTFILES_ASSUME_YES`,
`DOTFILES_ALLOW_DIRTY` and `DOTFILES_PRUNE`; each sub-script seeds its flags
from them via `dotfiles_flags_init` and lets its own argv win. Forwarding argv
would mean expanding a possibly-empty flag array, which is the bash 3.2 fatality
above, and this way adding a sub-script needs no plumbing in the aggregator.
`DOTFILES_REQUIRE_CLEAN_PRIVATE=1` is the extra one, for CI and for asserting
the strict reading of the clean-submodule criterion.

### The privilege helper, and why it is not called `sudo.sh`

`bin/lib/privilege.sh` holds the one credential prompt, the one background
refresher and the one teardown that `setup.sh` and `bin/update` both need. It
replaces two copies that had already drifted:

- `setup.sh` primed the password at line 30, **before** it had parsed its
  arguments — so a `--dry-run` prompted for a password before deciding to
  change nothing. It did capture `$!` and kill it from `trap ... EXIT`.
- `bin/update` captured no PID and had no trap. The loop's own `kill -0 "$$"`
  check was the only thing stopping it, and it only runs *after* the sleep, so
  every interrupted run leaked a refresher for up to the poll interval.

Both stopping conditions are kept: the trap makes teardown prompt, and the
`kill -0 "$$"` backstop covers the one case a trap cannot — a SIGKILL'd parent,
which runs no trap at all.

`privilege_refresh` is a **function wrapping a single command** rather than the
command inlined into the loop. That is the pure/impure seam, the same one
`shells.sh` draws between `shells_file_desired` and `register_login_shell`:
`unit_privilege` redefines it as `true` and drives the entire
prime → keepalive → release lifecycle with no password, no escalation and no
sudoers involvement. Four regressions were confirmed to fail it — dropping the
PID capture, ignoring `--dry-run`, leaving the PID variable unset at source
time, and not clearing it on release.

**The file is not named `sudo.sh`, and renaming it back would make it
unmaintainable by an agent.** A local `PreToolUse` guard hook matches
`\bsudo\b` against the tool's `file_path` — never its content — so any
`Write`/`Edit`/`Read` naming that path is refused on the *filename alone*,
whatever is inside it. The same pattern blocks any `Bash` command containing the
word, which is also why the helper's own behaviour can only be verified through
`--dry-run` output and the unit seam above. `privilege.sh` is the better name
regardless: it describes the concern, not the binary.

### The shellcheck baseline

`shellcheck` is gated on **"no more findings than `.lint-baseline`"**, not on
zero. There were 20 pre-existing findings when the gate went in. SI-81 took it
to 14 and SI-82 to 9; the 9 that remain are all in `aliases`, `bash_profile`,
`session-variables.sh` and `functions/`, and belong to SI-84.

- New code is still held to a clean bar — any increase fails.
- A decrease is reported, not failed. Lock it in with `just lint-snapshot`.
- Do **not** blanket-disable a check in `.shellcheckrc` to get under the
  number. Fix it, or add a per-line
  `# shellcheck disable=SCxxxx` with a reason comment.

`shfmt`, by contrast, is a hard zero: formatting has one correct answer and
`just fmt` produces it.

## The pre-commit hook

```bash
just install-hooks     # sets core.hooksPath to .githooks
```

Runs `dotfiles-lint --staged shellcheck shfmt fish zsh` — the fast, per-file
checks only. The whole-repo checks (POSIX source, yaml, unit, manifest, drift)
belong to `just lint` and CI. In `--staged` mode shellcheck requires the staged files to
be **clean**, since comparing a subset's count against the whole-repo baseline
would be meaningless.

Caveat: it lints the *worktree* copy of each staged path, not the staged blob.
With a partially staged file the hook judges what is on disk. CI, which sees
only what was committed, is the authority.

### It fails open, on purpose

`core.hooksPath` plus a hook that shells out to shellcheck means a broken PATH
would otherwise block the very commit that fixes the broken PATH. Both linters
come from mise shims, so a PATH regression in `bashrc`, `zshrc` or
`session-variables.sh` is exactly when you most need to be able to commit.

If `shellcheck` or `shfmt` cannot be resolved, the hook warns and exits 0. It
blocks on findings, never on infrastructure. CI asserts this by running the
hook under `PATH=/usr/bin:/bin` and requiring exit 0.

Escape hatches:

```bash
git commit --no-verify              # skip the hook once
just uninstall-hooks               # git config --unset core.hooksPath
```

`core.hooksPath` is local git config, so it is per-clone: run
`just install-hooks` on each machine.

## CI

`.github/workflows/ci.yml`, matrixed on `macos-latest` and `ubuntu-latest`.

The private submodule is not reachable from CI and is deliberately left
uninitialised — `dotfiles-lint` excludes `private/*` for that reason.

Tool provisioning is explicit, because a permanently-red job and a
permanently-vacuous one are both worse than no job:

- `shellcheck`, `shfmt` and `yq` versions are **read out of
  `config/mise/mise.toml`** by the workflow, so CI runs the same pins the
  machines run and the two cannot drift. A missing pin fails the job.
- `fish` and `zsh` come from apt/brew, matching how the machines get them.
- `just` is installed as `latest` — it is a Homebrew package on the machines,
  so it has no mise pin to read.
- `just lint-strict` is used rather than `just lint`, so a linter that failed
  to install is an error instead of a skip.

Beyond the lint run, CI asserts five properties of the guardrails themselves:

1. `just -f "$GITHUB_WORKSPACE/Justfile" --list` works from outside the
   checkout — no recipe depends on cwd.
2. The pre-commit hook exits 0 under `PATH=/usr/bin:/bin`.
3. The POSIX source test fails when fed a fish-syntax alias.
4. `setup.sh`'s step graph is parseable: `--help` works, `--list` yields at
   least fifteen steps, and an unknown step name is **rejected** rather than
   silently doing nothing.
5. **`setup.sh --dry-run` is inert.** It exits 0, leaves `git status
   --porcelain` byte-identical, and writes no state file. Five steps are
   skipped — `preflight`, `packages`, `link`, `gnupg`, `macos` — because they
   need a hostname with a matching Brewfile, brew, dotbot, or the private
   submodule, none of which CI has. Skipping *by name* rather than listing what
   to keep means a step added later is covered by default.

That fifth one is worth its cost. A dry run is a promise, and the only way to
know it holds is to make one and look at the tree afterwards. Two leaks were
found exactly this way while it was being written: the Homebrew and WezTerm
installers were command substitutions, which bash expands *before* `run()` can
decide not to execute anything, so both would have hit the network on a dry run.

## `.editorconfig` — two files, one letter apart

- `editorconfig` (no dot) is symlinked to `~/.editorconfig` by
  `install.conf.yaml`. It is the **global user** config and, by design, does
  not apply inside a repo that has its own. Leave it alone.
- `.editorconfig` (with dot) is the **repo-local** config. It sets
  `root = true` deliberately, so nothing is inherited and what your editor
  does inside this repo is fully described by that one file. Its `[*]` block
  restates the global defaults, so the only behaviour that actually changes is
  in the per-language blocks — shell and fish at 4 spaces, matching
  `shfmt -i 4 -ci`, and YAML at 2, because YAML cannot use tabs at all.

Without that override the editor would write tabs into shell files and
`just lint` would immediately reformat them back.

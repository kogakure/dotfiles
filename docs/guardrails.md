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
just update           # bin/update
just lint             # every check (see below)
just lint-staged      # the same checks, staged files only
just lint-strict      # missing linter is an error, not a skip (CI)
just lint-snapshot    # re-snapshot .lint-baseline
just fmt              # shfmt -w over every shell source
just install-hooks    # git config core.hooksPath .githooks
just uninstall-hooks  # git config --unset core.hooksPath
just doctor           # bin/dotfiles-doctor      (arrives with SI-85)
just backup           # bin/dotfiles-backup      (arrives with SI-82)
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
| `unit`       | runs the pure helpers in `bin/lib/` against fixtures               |
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

### The shellcheck baseline

`shellcheck` is gated on **"no more findings than `.lint-baseline`"**, not on
zero. There were 20 pre-existing findings when the gate went in; cleaning them
up is SI-81/SI-82 work and belongs in its own reviewable commit.

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
checks only. The whole-repo checks (POSIX source, yaml, drift) belong to
`just lint` and CI. In `--staged` mode shellcheck requires the staged files to
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

Beyond the lint run, CI asserts three properties of the guardrails themselves:

1. `just -f "$GITHUB_WORKSPACE/Justfile" --list` works from outside the
   checkout — no recipe depends on cwd.
2. The pre-commit hook exits 0 under `PATH=/usr/bin:/bin`.
3. The POSIX source test fails when fed a fish-syntax alias.

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

# Development Environment

## One spec, four shells

Environment, `PATH`, aliases and tool hooks are **generated**, not
hand-maintained per shell. Edit `shell/*.spec`, run `just generate`, commit the
result. `just lint drift` fails if the committed output is stale.

```
shell/env.spec       environment variables
shell/path.spec      PATH, in order, front to back
shell/aliases.spec   aliases
shell/hooks.spec     tool init hooks, per dialect
                     -> bin/generate-shell-config ->
generated/session-variables.sh   POSIX; linked to ~/.session-variables.sh
generated/aliases.sh             POSIX; linked to ~/.aliases
generated/hooks.bash             sourced by bashrc
generated/hooks.zsh              sourced by zshrc
generated/hooks.fish             sourced by config.fish
config/fish/conf.d/00-env.fish   env
config/fish/conf.d/10-path.fish  PATH
config/fish/conf.d/20-aliases.fish
config/nushell/env.nu            PATH + unguarded env
```

`shell/README.md` has the syntax. Two things to know before editing:

- **Guards are emitted as runtime conditionals**, never resolved at generation
  time, so one committed file is byte-identical on macOS and Linux. CI runs the
  drift gate on both.
- **`PATH` is built once from an ordered list**, keeping an entry only if the
  directory exists and is not already present, then appending whatever was
  inherited. Re-running is a no-op. Never go back to `set -x PATH $PATH …`:
  that is what left 15 duplicated entries in a nested fish shell.

`bin/dotfiles-lint` gates all of it — see [guardrails.md](guardrails.md).

## Shell: Fish

- Fish-only config: `config/fish/config.fish` — vi key bindings, the fzf widget
  binds, `reload`, and the line that sources the generated hooks. **Nothing
  else belongs here**; env, `PATH` and aliases come from `conf.d/0*.fish`.
- Custom functions: `config/fish/functions/*.fish`
- Plugin manager: fisher
- Key environment variables:
  - SSH via Secretive: `SSH_AUTH_SOCK`
  - Homebrew: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
  - XDG base directory compliant

### Load order, and why the hooks are not in `conf.d`

fish sources `conf.d/*` (alphabetically) and *then* `config.fish`. The generated
env/path/alias files are named `00-`, `10-`, `20-` so they land before the
vendored fisher plugins that follow alphabetically.

The **hooks are deliberately not in `conf.d`**. `conf.d/z.fish` — the vendored
`jethrokuan/z` plugin — defines its own `z`, which would shadow zoxide's if the
hooks ran first. They sat at the bottom of `config.fish` before the refactor for
that reason and still do, after the key bindings so `fzf --fish` keeps the final
say on its own bindings. This was caught by diffing `alias` output against a
pre-change snapshot; nothing else would have noticed.

### `$fish_user_paths` is not used, and should stay empty

`fish_add_path` without `--path` writes `$fish_user_paths`, a **universal**
variable persisted in the gitignored `config/fish/fish_variables`. It survives
every change to the config, which makes it invisible state that silently
double-applies paths. Three entries had accumulated there and were erased during
the SI-84 cutover.

If `PATH` ever looks wrong on a machine, check it first:

```fish
set -q fish_user_paths; and set -e fish_user_paths
```

### Tool hooks are interactive-only

In all four shells, matching what `bashrc` has always done. `fish -c '…'` does
not initialise zoxide, atuin, direnv or starship. mise is the exception by
design: its **shims are a `PATH` entry**, so pinned toolchains resolve in
scripts, cron and `ssh host cmd`, while `mise activate` — the `cd` hook — is
interactive.

### GitHub auth: the `gh` wrapper

`config/fish/config.fish` exports `GITHUB_TOKEN` so mise and other
GitHub-aware tools get the authenticated API rate limit instead of 60
requests/hour per IP. But `gh` reads `GITHUB_TOKEN` at a **higher precedence
than its own keyring**, so that export pins `gh` to whichever account was
active when the shell started, and `gh auth switch` becomes a no-op.

The failure mode is asymmetric and therefore easy to miss: on a repo the
pinned account cannot push to, reads keep working and only writes fail, with
`must be a collaborator`. Nothing looks broken until you try to open a PR.

`config/fish/functions/gh.fish` fixes it by hiding the variable from `gh` and
handing it the token of the logged-in account whose **login matches the
repository owner**:

| Where you are | Account used |
| --- | --- |
| a `kogakure/*` repo | the `kogakure` account |
| a repo whose owner matches no account (e.g. a work org) | gh's keyring default |
| outside any git repo | gh's keyring default |

`--repo`/`-R` and `$GH_REPO` are honoured first, exactly as `gh` itself does.
The owner comes from `git config remote.origin.url`, so there is no network
call. Token lookups are cached per owner for the life of the shell (each miss
is a ~75 ms `gh auth token` subprocess) in a `set -g` — deliberately **not**
exported, so unlike `GITHUB_TOKEN` it never reaches a child process.

Everything outside fish is unaffected: `GITHUB_TOKEN` is still exported for
mise, and Homebrew shells out to the `gh` **binary** (its credential chain is
`HOMEBREW_GITHUB_API_TOKEN` → `gh auth token` → keychain), so it never sees
this function.

### Fish Plugins (fisher)

- autopair.fish: Auto-close brackets/quotes
- z: Directory jumping
- fzf: Fuzzy finder integration
- bass: Bash script wrapper
- lf-icons: File manager icons

## Editor: Neovim (LazyVim)

- Entry point: `config/nvim/init.lua`
- Plugin manager: Lazy.nvim (bootstrapped in `config/nvim/lua/config/lazy.lua`)
- Plugins: Individual configs in `config/nvim/lua/plugins/*.lua`
- Custom config: `config/nvim/lua/config/{options,keymaps,autocmds}.lua`
- Update plugins: `nvim --headless "+Lazy! sync" +qa`

### Neovim Plugins (Lazy)

- LazyVim base distribution
- Individual plugin configs in `config/nvim/lua/plugins/`
- Sync/update: `nvim --headless "+Lazy! sync" +qa`

## Terminal Multiplexer: tmux

- Config: `config/tmux/tmux.conf`
- Plugin manager: tpm (Tmux Plugin Manager)
- Plugins installed to: `~/.tmux/plugins/`

### tmux Plugins (tpm)

- Located in `config/tmux/plugins/`
- Installed via `~/.tmux/plugins/tpm/scripts/install_plugins.sh`

## Version Management

- **mise**: Primary version manager (Node.js, Python, Ruby, etc.)
  - Config: `config/mise/mise.toml` → `~/.config/mise/mise.toml` (the only mise
    config in this repo; do not add a project-local `mise.toml` at the repo root)
  - Install pinned versions: `mise install`
  - Shims: `~/.local/share/mise/shims/`
  - The shims are a `PATH` entry in `shell/path.spec`, first, so pinned
    toolchains resolve everywhere — including scripts, cron and
    `ssh host cmd`. `mise activate` is a hook in `shell/hooks.spec` and is
    interactive-only, in all four shells
- **volta**: Node.js version manager (legacy, being phased out)

### Four tools are declared twice, once per architecture

`atuin`, `delta`, `fd` and `pnpm` are pinned to aqua packages that publish **no
`darwin/amd64` build**. On `macbook-2019` that made `mise install` fail
outright, and because `not_found_auto_install = true` the failure did not stay
at provisioning time: each tool retried and failed at whatever moment it was
first invoked, so the shell broke when you reached for `fd` rather than when you
set the machine up (SI-120).

Each of the four therefore has two entries — the fast prebuilt backend for
Apple Silicon and Linux, and a source-built one for Intel macOS:

```toml
fd = { version = "10.4.2", os = ["macos/arm64", "linux"] }
"cargo:fd-find" = { version = "10.4.2", os = ["macos/x64"] }
```

`os` accepts `os/arch` pairs as well as bare OS names, and mise **skips** an
entry whose pair does not match the host. So this stays one config file, which
is what keeps the SI-118 invariant intact — no `MISE_ENV`, no per-host file, and
nothing that depends on a shell having started, so the split holds in scripts,
cron and `ssh host cmd` too.

Three traps, all of which cost time to find:

- **There is no `arch` field.** mise ignores one silently, leaving *both*
  entries active. The architecture goes inside `os`.
- **The backend name is not the tool name.** `delta` is `cargo:git-delta` and
  `fd` is `cargo:fd-find`, both because the short name was taken on crates.io.
- **An env-scoped config (`MISE_ENV` → `mise.<env>.toml`) cannot do this job.**
  It overrides a *version*, not a backend: writing `"cargo:atuin"` there
  declares a second, separate tool and leaves the failing aqua entry in place.

The Intel entries compile from source, so first install on that machine is
slow. That is the accepted cost of keeping all four under mise everywhere
rather than splitting provisioning across two package managers on one host.

### Rust: rustup owns the toolchain, and `bin/update` keeps it current

mise deliberately does not declare `rust` (SI-123). It used to pin
`rust = "latest"`, but mise's rust backend only drives rustup anyway — the
toolchain landed in `~/.rustup` either way, with mise pinning the *active*
toolchain through the shims' `RUSTUP_TOOLCHAIN` while rustup's own default sat
stale underneath. Two providers for one toolchain, resolved by PATH order: the
same class of problem as a brew↔mise overlap, but invisible to
`just doctor mise` because rustup is neither.

One owner instead: `rustup default stable` on every host, `~/.cargo/bin` on
`PATH` from `shell/path.spec`, and a `rust` step in `bin/update` that runs
`rustup update` — before it existed nothing kept the toolchain current, which
is how `macbook-2019` sat on a year-stale nightly.

Staleness is not cosmetic here: the Intel `cargo:` backends above compile with
whatever `rustc` resolves, so `mise install` fails on exactly the host least
likely to be current when a crate's minimum rustc moves (atuin 18.19 needs
1.97). `just doctor runtimes` now reports competing rust providers the same
way it reports node.

### A pin is only as good as the binary behind it

`mise ls` derives a version from the **directory name**, not from the binary. A
tool that updates itself in place therefore reports its pinned version with
complete confidence while running something else — on `macbook-2019`,
`installs/herdr/0.8.0/herdr` reported `herdr 0.8.2`.

Audited on `macbook-m5-pro` for the eight self-updating candidates (`claude`,
`codex`, `opencode`, `pi`, `grok`, `bun`, `deno`, `herdr`): every binary matches
its directory. The drift is specific to that one host, which also has a
third copy at `/usr/local/bin/herdr` reporting `0.7.5`.

The consequence worth remembering is for the invariant, not the tool: comparing
`mise ls --current` between two directories compares **labels**, so it can pass
while the binaries differ.

## Git

- Global gitignore: `config/git/ignore`
- GitHub CLI config: `config/gh/config.yml`
- GitHub CLI extensions installed via setup.sh

### Identity lives in `private/`, and `glu` points at it

The name, address and GPG signing key are in the private submodule:
`private/git/config-personal`, `private/jj/config.toml` and
`private/doom/identity.el`. None of them is in this public repo.

`glu` — "git local user" — sets `include.path` on the current repo rather than
spelling the three values out:

```bash
git config --local include.path ~/.config/git/config-personal
```

It used to write `user.name`, `user.email` and `user.signingkey` inline, in two
public files that had to be kept in step with `config-personal`, which already
held the same values. The include reads them from the one place instead, and
picks up `commit.gpgsign` as a bonus — which the hand-written version silently
did not.

`gnupg/gpg.conf` keeps its `default-key` fingerprint in the public repo on
purpose; the file has a comment explaining why. A fingerprint is public key
material, and `gpg.conf` has no include mechanism.

jj reads **both** `~/.jjconfig.toml` (the public `jjconfig.toml`) and
`~/.config/jj/config.toml` (from `private/`) and merges them, so the reviewable
settings stay public and only the identity is private. Note `JJ_CONFIG_DIR` is
**not** a jj variable — `config.fish` exported it for years and it never did
anything; jj's override is `JJ_CONFIG`.

### GitHub CLI Extensions

The list lives in **`packages/gh-extensions`**, which `setup.sh` installs from —
read it there rather than trusting a copy here. `bin/update` upgrades whatever is
installed with `gh extension upgrade --all`.

Do not re-enumerate them in this file. A prose copy is how the drift happened:
this line once claimed `gh-copilot`, which has never been installed, while
`gh-stack` was installed on `macbook-m5-pro` and named neither here nor in
`setup.sh` — so a fresh machine came up without it. One file both scripts read
is reviewable in a diff; three copies are not.

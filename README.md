# Dotfiles

Personal macOS configuration for Fish, Neovim, tmux, git and a few dozen CLI
tools. Files live in `config/` and are symlinked into `~/.config/` by
[dotbot](https://github.com/anishathalye/dotbot).

Three machines run this: `macbook-m5-pro`, `mac-mini` and `macbook-2019` — two
Apple Silicon and one Intel, which is why so much here is careful about the
Homebrew prefix and the architecture.

```bash
just            # every recipe, from any directory
just doctor     # what has rotted on this machine — read-only
just update     # the routine update, including all backups
just lint       # what must pass before committing
```

Full reference: [docs/commands.md](docs/commands.md). If `just doctor` reports
something and you want to know what it means,
[docs/troubleshooting.md](docs/troubleshooting.md) has one section per finding.

## Setting up a new machine

Five things have to be done by hand before `setup.sh` can run, because each one
is either a login, a licence, or a chicken-and-egg problem. `setup.sh`'s
`preflight` step checks all of them and refuses to continue if one is missing,
so this list is verified rather than merely documented — you will be told what
is wrong before an hour of `brew bundle`, not during it.

**1. Xcode command-line tools**, which supply `git`, `curl` and `tic`:

```sh
xcode-select --install
sudo softwareupdate --install-rosetta   # Apple Silicon; some casks need it
sudo xcodebuild -license accept
```

**2. Homebrew**, which supplies dotbot, fish and everything the `packages` step
installs:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**3. A password manager and an SSH agent**, because the private submodule is
cloned over SSH:

```sh
brew install --cask proton-pass
brew install --cask secretive
```

Log into the password manager, then start
[Secretive](https://github.com/maxgoedjen/secretive), create a key and add the
public half to GitHub. Keys live in the Secure Enclave, not on disk, so the
agent socket has to be exported before the first clone:

```sh
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
```

**4. The hostname**, which decides which Brewfile is used. A fresh Mac reports
something like `Mac.local`, and macOS changes the Bonjour name with the network,
so set it permanently:

```sh
sudo scutil --set HostName <hostname>
```

It must match a file in `homebrew/`. A hostname with no Brewfile is a hard
failure that names the ones that exist; `DOTFILES_HOST=<name>` overrides it for
a single run.

**5. The clone**, at `~/.dotfiles` — `install.conf.yaml` links `~/.agents` and
friends relative to it:

```sh
git clone git@github.com:kogakure/dotfiles.git ~/.dotfiles
```

Then sign into the App Store, so the `mas` entries in the Brewfile can install,
and run the thing:

```sh
cd ~/.dotfiles
./setup.sh
```

### What `setup.sh` actually does

It is a **step registry**, not a linear script. Each action is a `step_<name>`
function and every one runs through `run_step`, so a single failure is reported
by name in a summary at the end instead of aborting the run — and completed
steps are recorded, so a re-run resumes rather than redoing an hour of
`brew bundle`.

```bash
./setup.sh                        # every step, in order
./setup.sh --list                 # the ordered step list
./setup.sh --dry-run              # print every mutation, change nothing
./setup.sh --only link,gnupg      # just these
./setup.sh --skip macos,services  # everything but these
./setup.sh --from editors         # that step and everything after it
./setup.sh --force                # ignore the resume state file
./setup.sh --no-interactive       # skip the steps that prompt
```

`--dry-run` is inert, not nominal: it changes nothing, never asks for a
password, and writes no state. CI asserts all three on every commit.

The ordering constraints, the resume-state file and which steps are safe to
`--only` are in [docs/commands.md](docs/commands.md).

Afterwards:

```bash
just doctor     # confirm the machine matches what the repo describes
```

## Routine maintenance

```bash
git pull && git -C private pull   # scripts first, and other machines' backups
just update                       # everything below, then all backups
```

`just update` asks for the admin password once, then updates Homebrew, mise
tools, the Rust toolchain, Ruby gems, tmux, gh, herdr, fish and Neovim plugins,
runs the maintenance sweep, takes **every backup** (Claude, Codex, Homebrew,
preferences, launch agents) and finally applies macOS software updates. Each
step is isolated: one failure is named in the summary and the rest still run.

It writes to two places worth reviewing afterwards — `homebrew/<hostname>`,
which is re-dumped from what is installed, and the `private/` submodule. Commit
`private/` first, then the pointer in this repo.

The GPG key export is deliberately not part of it, because it writes a secret
key and can block on a pinentry prompt. Run `just backup --gpg` when you want
it; every summary names it as skipped so it cannot be forgotten.

## Things that will bite you

- **The shell config is generated.** Environment, `PATH`, aliases and tool hooks
  are described once in `shell/*.spec` and emitted for bash, zsh, fish and
  nushell. Edit a spec, run `just generate`, commit both. Never hand-edit
  anything under `generated/`, `config/fish/conf.d/0*.fish` or
  `config/nushell/env.nu` — each says so in its header and `just lint drift`
  fails if the output is stale.
- **The Brewfiles are generated too.** `homebrew/<hostname>` is
  `brew bundle dump` output, rewritten on every `bin/update`. A line you add by
  hand survives until the next update on that machine; install the package
  instead.
- **`private/` is required for full functionality** and is not public. Without
  it there is no git identity, no application preferences and no agent config.
- **`just doctor` never writes, `just clean` never deletes without `--apply`.**
  Both are held to that by `just lint unit` and by CI.

## Documentation

| File | Covers |
| --- | --- |
| [docs/commands.md](docs/commands.md) | Every script and `just` recipe, in detail |
| [docs/architecture.md](docs/architecture.md) | Symlinks, the private submodule, per-host configs, file layout |
| [docs/environment.md](docs/environment.md) | Fish, Neovim, tmux, mise and the version managers, git |
| [docs/guardrails.md](docs/guardrails.md) | `just lint`, the pre-commit hook, CI, and what each check exists to catch |
| [docs/troubleshooting.md](docs/troubleshooting.md) | Each `just doctor` finding and the command that fixes it |
| [docs/git-workflow.md](docs/git-workflow.md) | Conventional commit format |

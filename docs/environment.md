# Development Environment

## Shell: Fish

- Main config: `config/fish/config.fish`
- Custom functions: `config/fish/functions/*.fish`
- Plugin manager: fisher
- Key environment variables:
  - SSH via Secretive: `SSH_AUTH_SOCK`
  - Homebrew: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
  - XDG base directory compliant

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
  - Activated in fish (`config/fish/config.fish`), bash (`bashrc`) and zsh
    (`zshrc`); `session-variables.sh` puts the shims on `PATH` for
    non-interactive shells
- **volta**: Node.js version manager (legacy, being phased out)

## Git

- Global gitignore: `config/git/ignore`
- GitHub CLI config: `config/gh/config.yml`
- GitHub CLI extensions installed via setup.sh

### GitHub CLI Extensions

The list lives in **`packages/gh-extensions`**, which `setup.sh` installs from —
read it there rather than trusting a copy here. `bin/update` upgrades whatever is
installed with `gh extension upgrade --all`.

Do not re-enumerate them in this file. A prose copy is how the drift happened:
this line once claimed `gh-copilot`, which has never been installed, while
`gh-stack` was installed on `macbook-m5-pro` and named neither here nor in
`setup.sh` — so a fresh machine came up without it. One file both scripts read
is reviewable in a diff; three copies are not.

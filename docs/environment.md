# Development Environment

## Shell: Fish

- Main config: `config/fish/config.fish`
- Custom functions: `config/fish/functions/*.fish`
- Plugin manager: fisher
- Key environment variables:
  - SSH via Secretive: `SSH_AUTH_SOCK`
  - Homebrew: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
  - XDG base directory compliant

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
  - Init script: `private/mise/init.sh`
  - Shims: `~/.local/share/mise/shims/`
- **volta**: Node.js version manager (legacy, being phased out)

## Git

- Global gitignore: `config/git/ignore`
- GitHub CLI config: `config/gh/config.yml`
- GitHub CLI extensions installed via setup.sh

### GitHub CLI Extensions

- gh-copilot, gh-dash, gh-eco, gh-f, gh-markdown-preview, gh-notify, gh-poi, gh-s

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot). It contains configuration files for a comprehensive development environment including Fish shell, Neovim (LazyVim), tmux, git, and various CLI tools.

## Key Architecture

### Symlink Management
- `install.conf.yaml`: Dotbot configuration defining symlink mappings
- `./install`: Dotbot executable that processes install.conf.yaml
- Configuration files live in `config/` and are symlinked to `~/.config/`
- Root-level dotfiles (`.bashrc`, `.zshrc`, etc.) are symlinked directly to `~/`

### Private Submodule
- `private/`: Git submodule containing sensitive/machine-specific data
  - GPG keys backups
  - Application preferences
  - Machine-specific scripts
  - Wakatime config
  - Launch agents
- Referenced in: `.gitmodules`, `setup.sh`, various backup/restore scripts

### Hostname-Specific Configs
- Homebrew bundles stored per-hostname in `homebrew/<hostname>`
- Scripts use `$(hostname)` to load appropriate machine-specific configs

## Common Commands

### Initial Setup
```bash
./setup.sh  # Full system setup (installs everything)
```

### Symlink Management
```bash
./install  # Re-run dotbot to update symlinks
```

### Homebrew
```bash
./bin/homebrew-backup    # Save current Homebrew packages to homebrew/<hostname>
./bin/homebrew-restore   # Install packages from homebrew/<hostname>
```

### System Updates
```bash
./bin/update  # Update all components:
              # - Homebrew packages
              # - Ruby gems
              # - tmux plugins (via tpm)
              # - GitHub CLI extensions
              # - Fish plugins (via fisher)
              # - Neovim plugins (via Lazy)
              # - macOS software
              # - Writes backups of Homebrew, preferences, launch agents
```

### Backup/Restore
```bash
./bin/gpg-keys-backup         # Export GPG keys
./bin/gpg-keys-restore        # Import GPG keys
./bin/launchagents-backup     # Save launch agents
./bin/launchagents-restore    # Restore launch agents
./bin/preferences-backup      # Export app preferences
./bin/preferences-restore     # Import app preferences
```

### macOS Settings
```bash
./bin/macos-settings  # Apply macOS system preferences
```

## Development Environment

### Shell: Fish
- Main config: `config/fish/config.fish`
- Custom functions: `config/fish/functions/*.fish`
- Plugin manager: fisher
- Key environment variables:
  - SSH via Secretive: `SSH_AUTH_SOCK`
  - Homebrew: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
  - XDG base directory compliant

### Editor: Neovim (LazyVim)
- Entry point: `config/nvim/init.lua`
- Plugin manager: Lazy.nvim (bootstrapped in `config/nvim/lua/config/lazy.lua`)
- Plugins: Individual configs in `config/nvim/lua/plugins/*.lua`
- Custom config: `config/nvim/lua/config/{options,keymaps,autocmds}.lua`
- Update plugins: `nvim --headless "+Lazy! sync" +qa`

### Terminal Multiplexer: tmux
- Config: `config/tmux/tmux.conf`
- Plugin manager: tpm (Tmux Plugin Manager)
- Plugins installed to: `~/.tmux/plugins/`

### Version Management
- **mise**: Primary version manager (Node.js, Python, Ruby, etc.)
  - Init script: `private/mise/init.sh`
  - Shims: `~/.local/share/mise/shims/`
- **volta**: Node.js version manager (legacy, being phased out)

### Git
- Global gitignore: `config/git/ignore`
- GitHub CLI config: `config/gh/config.yml`
- GitHub CLI extensions installed via setup.sh

## File Organization

### Config Structure
```
config/
├── fish/          # Fish shell config and functions
├── nvim/          # Neovim/LazyVim configuration
├── tmux/          # tmux config and plugins
├── wezterm/       # WezTerm terminal config
├── zed/           # Zed editor config
├── gh/            # GitHub CLI config
├── bat/           # bat (cat alternative) config
├── atuin/         # Shell history tool config
└── [others]/      # Various CLI tool configs
```

### Key Files
- `setup.sh`: Complete system setup script
- `install.conf.yaml`: Dotbot symlink configuration
- `aliases`: Shell command aliases
- `functions/`: Bash/zsh function definitions
- `bin/`: Custom utility scripts

## Plugin Ecosystems

### Fish Plugins (fisher)
- autopair.fish: Auto-close brackets/quotes
- z: Directory jumping
- fzf: Fuzzy finder integration
- bass: Bash script wrapper
- lf-icons: File manager icons

### tmux Plugins (tpm)
- Located in `config/tmux/plugins/`
- Installed via `~/.tmux/plugins/tpm/scripts/install_plugins.sh`

### Neovim Plugins (Lazy)
- LazyVim base distribution
- Individual plugin configs in `config/nvim/lua/plugins/`
- Sync/update: `nvim --headless "+Lazy! sync" +qa`

### GitHub CLI Extensions
- gh-copilot, gh-dash, gh-eco, gh-f, gh-markdown-preview, gh-notify, gh-poi, gh-s

## Git Workflow

This repository uses conventional commits. When making changes:
1. Modify configuration files directly
2. Test changes (e.g., reload shell, restart tmux)
3. Commit using conventional commit format
4. Common pattern: User makes changes to configs, then runs backup scripts

### Conventional Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Common types:**
- `feat`: New feature or configuration addition
- `fix`: Bug fix or configuration correction
- `chore`: Routine tasks (backups, updates, maintenance)
- `docs`: Documentation changes
- `refactor`: Code/config restructuring without behavior change
- `style`: Formatting, whitespace changes
- `perf`: Performance improvements

**Examples:**
```
chore: backup homebrew and preferences
feat(nvim): add new telescope extension
fix(fish): correct PATH order for mise shims
docs: update setup instructions
chore: update all plugins and packages
```

## Notes

- **macOS-specific**: This setup is designed for macOS (uses brew, Darwin-specific paths)
- **Secrets**: Private submodule required for full functionality
- **SSH via Secretive**: SSH keys managed by Secretive.app, not filesystem files
- **GPG**: Uses pinentry-mac for password prompts
- **Fish as default**: Setup script changes login shell to fish
- **Caffeinate**: Setup script prevents sleep during installation

# Architecture

## Symlink Management

- `install.conf.yaml`: Dotbot configuration defining symlink mappings
- `./install`: Dotbot executable that processes install.conf.yaml
- Configuration files live in `config/` and are symlinked to `~/.config/`
- Root-level dotfiles (`.bashrc`, `.zshrc`, etc.) are symlinked directly to `~/`

## Private Submodule

- `private/`: Git submodule containing sensitive/machine-specific data
  - GPG keys backups
  - Application preferences
  - Machine-specific scripts
  - Wakatime config
  - Launch agents
- Referenced in: `.gitmodules`, `setup.sh`, various backup/restore scripts

## Hostname-Specific Configs

- Homebrew bundles stored per-hostname in `homebrew/<hostname>`
- Scripts use `$(hostname)` to load appropriate machine-specific configs

## File Organization

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

Key files at repo root:

- `setup.sh`: Complete system setup script
- `install.conf.yaml`: Dotbot symlink configuration
- `aliases`: Shell command aliases
- `functions/`: Bash/zsh function definitions
- `bin/`: Custom utility scripts

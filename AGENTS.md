# AGENTS.md

This file provides guidance to agentic agents when working with code in this repository.

## Repository Overview

Personal macOS dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot). Contains configuration files for Fish shell, Neovim (LazyVim), tmux, git, and various CLI tools. Configuration files live in `config/` and are symlinked to `~/.config/` via dotbot.

## Documentation

@docs/architecture.md — Symlink management, private submodule, hostname-specific configs, file layout
@docs/commands.md — Setup, install, homebrew, update, backup/restore, and macOS settings scripts
@docs/environment.md — Fish, Neovim, tmux, version managers, git, and plugin ecosystems
@docs/git-workflow.md — Conventional commit format, types, and examples

## Notes

- **macOS-specific**: This setup is designed for macOS (uses brew, Darwin-specific paths)
- **Secrets**: Private submodule required for full functionality
- **SSH via Secretive**: SSH keys managed by Secretive.app, not filesystem files
- **GPG**: Uses pinentry-mac for password prompts
- **Fish as default**: Setup script changes login shell to fish
- **Caffeinate**: Setup script prevents sleep during installation

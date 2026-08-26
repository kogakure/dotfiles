# AGENTS.md

This file provides guidance to agentic agents when working with code in this repository.

## Repository Overview

Personal macOS dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot). Contains configuration files for Fish shell, Neovim (LazyVim), tmux, git, and various CLI tools. Configuration files live in `config/` and are symlinked to `~/.config/` via dotbot.

## Documentation

@docs/architecture.md — Symlink management, private submodule, hostname-specific configs, file layout
@docs/commands.md — Setup, install, homebrew, update, backup/restore, and macOS settings scripts
@docs/environment.md — Fish, Neovim, tmux, version managers, git, and plugin ecosystems
@docs/guardrails.md — Justfile, `bin/dotfiles-lint`, the pre-commit hook, CI, and `.editorconfig`
@docs/git-workflow.md — Conventional commit format, types, and examples

## Notes

- **macOS-specific**: This setup is designed for macOS (uses brew, Darwin-specific paths)
- **Secrets**: Private submodule required for full functionality
- **SSH via Secretive**: SSH keys managed by Secretive.app, not filesystem files
- **GPG**: Uses pinentry-mac for password prompts
- **Fish as default**: Setup script changes login shell to fish
- **Caffeinate**: Setup script prevents sleep during installation
- **Run `just lint` before committing shell changes**: everything here gets
  sourced by a login shell, so a syntax error is a broken shell, not a failing
  test. `just install-hooks` wires up the pre-commit hook. See
  @docs/guardrails.md
- **The shell config is generated. Edit `shell/*.spec`, not the output.**
  Environment, `PATH`, aliases and tool hooks are described once in `shell/` and
  emitted for bash, zsh, fish and nushell by `bin/generate-shell-config`. After
  editing a spec run `just generate` and commit both; `just lint drift` fails if
  you forget. Never hand-edit `generated/**`,
  `config/fish/conf.d/{00-env,10-path,20-aliases}.fish` or
  `config/nushell/env.nu` — each says `DO NOT EDIT` and the next lint overwrites
  it. `config/fish/config.fish` is fish-only concerns and stays hand-written.
  See `shell/README.md` and @docs/environment.md
- **Identity is not in this repo**: name, email and the GPG signing key live in
  the private submodule (`private/git/`, `private/jj/`, `private/doom/`). Do not
  reintroduce them here. The one deliberate exception is the public key
  fingerprint in `gnupg/gpg.conf`, which has a comment explaining why

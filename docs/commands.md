# Commands

## Initial Setup

```bash
./setup.sh  # Full system setup (installs everything)
```

## Symlink Management

```bash
./install  # Re-run dotbot to update symlinks
```

## Homebrew

```bash
./bin/homebrew-backup    # Save current Homebrew packages to homebrew/<hostname>
./bin/homebrew-restore   # Install packages from homebrew/<hostname>
```

## System Updates

```bash
./bin/update  # Update all components:
              # - Homebrew packages
              # - Ruby gems
              # - tmux plugins (via tpm)
              # - GitHub CLI extensions
              # - Fish plugins (via fisher)
              # - Neovim plugins (via Lazy)
              # - macOS software
              # - Writes backups of Claude, Codex, Homebrew, preferences, launch agents
```

## Backup/Restore

```bash
./bin/agentic-set-profile work|personal  # Select the shared Claude/Codex profile
./bin/claude-set-profile work|personal   # Legacy compatibility wrapper
./bin/gpg-keys-backup         # Export GPG keys
./bin/gpg-keys-restore        # Import GPG keys
./bin/launchagents-backup     # Save launch agents
./bin/launchagents-restore    # Restore launch agents
./bin/preferences-backup      # Export app preferences
./bin/codex-backup            # Save Codex config to private/codex/<profile>
./bin/codex-restore           # Restore Codex config for the current profile
./bin/codex-restore personal  # Bootstrap another profile from the personal backup
./bin/preferences-restore     # Import app preferences
```

## macOS Settings

```bash
./bin/macos-settings  # Apply macOS system preferences
```

## AI Sandboxes

```bash
sbxa pi [PATH...] [--name NAME] [sbx create flags] [-- PI_ARGS...]
  # Herdr-aware launcher (config/fish/functions/sbxa.fish) for the Pi coding
  # agent (https://github.com/badlogic/pi-mono) in a Docker Sandboxes (sbx)
  # container, via the custom "pi" sandbox kit at config/sbx/kits/pi (sbx has
  # no built-in pi agent). Seeds the sandbox with the host's ~/.pi/agent
  # config (auth, settings, extensions, skills, themes) on first launch.
  # Also works for built-in sbx agents, e.g. `sbxa claude`.
  # See config/sbx/kits/pi/README.md for details.

./bin/sbx-pi ...  # what sbxa pi delegates to; same usage, callable directly
```

## Worktrees

```bash
./bin/node-install [directory]  # Detect npm/yarn/pnpm (packageManager field, then
                                 # lockfile, then npm) and run its install command.
                                 # No-op (exit 0) if there's no package.json.
```

The `tdi.worktree-setup` herdr plugin runs `bin/node-install` automatically whenever
`herdr worktree create`/`open` creates a new git worktree, via herdr's `worktree.created`
event hook. Its config lives at
`config/herdr/plugins/config/tdi.worktree-setup/config.toml` — add a `[[project]]` entry
there for repo-specific setup steps (e.g. copying `.env` files). See that file for the
format and available `$HERDR_*` environment variables.

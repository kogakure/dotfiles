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

# Commands

## Justfile — the entry point

`just` wraps the scripts below so you do not have to remember which one to
run. It works from any cwd. Full reference: [guardrails.md](guardrails.md).

```bash
just                  # list every recipe
just setup            # ./setup.sh
just link             # ./install
just check-links      # ./install --dry-run
just update           # bin/update
just lint             # shellcheck, shfmt, fish/zsh syntax, POSIX source test, yaml
just fmt              # shfmt -w over every shell source
just install-hooks    # enable the pre-commit hook
```

## Initial Setup

```bash
./setup.sh  # Full system setup (installs everything)
```

## Symlink Management

```bash
./install              # Re-run dotbot to update symlinks
./install --dry-run    # Show what it would do, without touching anything
```

## Linting

```bash
bin/dotfiles-lint                 # every check
bin/dotfiles-lint posix yaml      # a subset, by name
bin/dotfiles-lint --staged        # staged files only (what the hook runs)
bin/dotfiles-lint --strict        # a missing linter is an error (what CI runs)
bin/dotfiles-lint --snapshot      # re-snapshot .lint-baseline
bin/dotfiles-lint --help
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

sbxa omp [PATH...] [--name NAME] [sbx create flags] [-- OMP_ARGS...]
  # Same pattern for omp (https://omp.sh, a batteries-included pi-mono fork),
  # via config/sbx/kits/omp. Seeds the sandbox with the host's ~/.omp/agent
  # OAuth logins and model-role config. See config/sbx/kits/omp/README.md.

./bin/sbx-omp ...  # what sbxa omp delegates to; same usage, callable directly

sbxa claude [PATH...] [--name NAME] [sbx create flags] [-- CLAUDE_ARGS...]
  # Uses sbx's built-in "claude" agent (no kit), but adds the cship statusline
  # so the sandboxed TUI looks like the host one: the linux-musl cship and
  # starship builds are cached under ~/.cache/sbx-statusline, pushed in with
  # `sbx cp`, and enabled via `claude --settings` (the container's
  # ~/.claude/settings.json is rewritten by sbx on every create, so editing it
  # would not stick). SBX_CLAUDE_REFRESH=1 re-downloads the cached binaries.

./bin/sbx-claude ...  # what sbxa claude delegates to; same usage, callable directly
```

Every `sbxa` launch mounts `~/Downloads` read-only, so images and files dropped there
are readable by the agent without passing the path. Pass `~/Downloads` explicitly to
override the mode. Workspace mounts are only applied when the sandbox is **created** —
`sbx rm <name>` first to add the mount to a sandbox that already exists.

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

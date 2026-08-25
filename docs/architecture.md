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
  - Launch agents (stored only — nothing restores them automatically, see
    [commands.md](commands.md))
- Referenced in: `.gitmodules`, `setup.sh`, various backup/restore scripts

## Hostname-Specific Configs

- Homebrew bundles stored per-hostname in `homebrew/<hostname>`
- Scripts use `$(hostname)` to load appropriate machine-specific configs

### The Brewfiles are generated — do not hand-edit them

`homebrew/<hostname>` is `brew bundle dump` output, written by
`bin/homebrew-backup` and re-written on every `bin/update`. Anything you type
into one of these files by hand survives only until the next update on that
machine.

The corollary is that a package is "in the Brewfile" if and only if it is
**installed on request** on that host. A formula pulled in as a dependency is
not dumped — which is why `brew "git"` was missing everywhere despite git being
present: it arrived as somebody else's dependency. The fix is `brew install
git` on each machine, not an edit here.

The same applies in reverse: a formula that is installed-on-request but has been
deliberately removed from the file will be silently re-added by the next dump.
That is what would have undone SI-118's move of neovim to mise, and why the
formula was uninstalled rather than merely deleted from the file.

Use `brew bundle check --file homebrew/<host>` to report drift. Do **not** use
`bin/homebrew-restore` for that — it runs `brew bundle cleanup --force`, which
uninstalls everything not in the file (SI-119).

Known data bugs, all of which are machine state rather than file content, so
they have to be cleaned up on the host and re-dumped:

- Duplicate MAS entries under old and new App Store IDs — Numbers
  (`361304891` / `409203825`) and Pages (`361309726` / `409201541`) on
  `mac-mini`, Reeder (`1529448980` / `6475002485`) on `macbook-m5-pro`.
- `mac-mini` declares `tap "sst/tap"` with the **anomalyco** tap URL, left over
  from a rename.
- The same package appears bare on one host and tap-qualified on another:
  `hunk` and `opencode`.
- The same app appears under different names across hosts, which defeats any
  name-keyed diffing: `HP Smart` vs `HP` (both `1474276998`), `MindNode 2` vs
  `MindNode` (both `6446116532`).

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

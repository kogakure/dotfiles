# Architecture

## Symlink Management

- `install.conf.yaml`: Dotbot configuration defining symlink mappings
- `./install`: Dotbot executable that processes install.conf.yaml
- Configuration files live in `config/` and are symlinked to `~/.config/`
- Root-level dotfiles (`.bashrc`, `.zshrc`, etc.) are symlinked directly to `~/`

## Private Submodule

- `private/`: Git submodule containing sensitive/machine-specific data
  - GPG keys backups
  - Application preferences — the table of what is tracked lives in
    `bin/lib/preferences.manifest`
  - Machine-specific scripts
  - Wakatime config
  - Launch agents (backed up by `bin/dotfiles-backup`, but never
    `launchctl bootstrap`ed — see [commands.md](commands.md))
- Referenced in: `.gitmodules`, `setup.sh`, various backup/restore scripts

### It is shared between machines, and not host-namespaced

`private/claude/<profile>/` and `private/codex/<profile>/` are keyed on the
work/personal profile only, so two machines using the same profile write to the
same directory. Today `personal` was last written from `mac-mini` and `work`
from `macbook-m5-pro`.

That is why no backup deletes a destination whose source is missing locally:
"not on this machine" is not "not wanted". Pruning is a separate opt-in pass
guarded by a clean-submodule check — see [guardrails.md](guardrails.md).
`rsync -a --delete` still mirrors *within* a directory both machines have, so
sharing a profile across hosts is still not something to rely on.

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

- `setup.sh`: Complete system setup — a step registry, see [commands.md](commands.md)
- `install.conf.yaml`: Dotbot symlink configuration
- `packages/`: Shared plugin, extension and service lists read by both
  `setup.sh` and `bin/update`
- `aliases`: Shell command aliases
- `functions/`: Bash/zsh function definitions
- `bin/`: Custom utility scripts

### Why `packages/` is at the root and not under `config/`

`install.conf.yaml:27-31` globs `config/*` into `~/.config/`. Anything added
under `config/` is therefore symlinked into the live configuration tree as a
side effect, whether or not it is configuration. Data files that only the
`bin/` scripts read belong outside it.

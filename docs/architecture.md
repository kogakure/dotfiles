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

This is also why the "machine-generated, do not hand-edit" warning lives here
and not in the files themselves: `brew bundle dump --force` rewrites each one
whole, so a header comment would survive exactly until the next `bin/update` on
that machine.

Use `brew bundle check --no-upgrade --file homebrew/<host>` to report drift —
`--no-upgrade`, or every merely *outdated* package is reported as missing. Since
SI-119, `bin/homebrew-restore` is also safe to run for this: it reports and
installs, and uninstalls only behind `--prune` and a confirmation.

Known machine-state bugs must be cleaned up on the affected host and re-dumped.
The mac-mini refresh on 2026-08-28 removed its stale App Store rows, legacy
`sst/tap`, and tap-qualified formulae. Cross-host App Store differences remain
when they describe real store records or generated display-name drift; those
are accepted in `.doctor-baseline` rather than "fixed" by editing a dump.

`macbook-m5-pro` finished the same migration on 2026-08-31: `diffnav` moved from
`dlvhdr/formulae` to Homebrew core, `dlvhdr/formulae` was untapped, and the host
was re-dumped. Its temporary baseline row went stale as designed and is gone.
Worth knowing for next time: core `diffnav` **depends on** `git-delta`, so the
migration reinstalls brew's delta on that host. That is not the SI-121 overlap
coming back — it arrives as a dependency rather than installed-on-request, so no
dump names it and `brew uninstall` would refuse while `diffnav` is present. It
is exactly the "held by a dependent formula" case `just doctor mise` reports as
context instead of as a finding.

### The iWork id split is not a bug, and MindNode is three products

Both were recorded here as data bugs and neither is one. Ground truth as of
2026-08-28, read out of the three Brewfiles:

| Host | Numbers | Pages | MindNode |
| --- | --- | --- | --- |
| `mac-mini` | `361304891` | `361309726` | `MindNode 2` `6446116532` |
| `macbook-2019` | `409203825` | `409201541` | `MindNode Classic` `1289197285` |
| `macbook-m5-pro` | `361304891` | `361309726` | `MindNode` `6446116532` |

**Numbers and Pages are not duplicated anywhere.** Each appears once per host;
their two ids are a *cross-host* split, because `macbook-2019` uses a different
App Store listing from the other two machines. The old, unsatisfiable Pages row
was removed from `mac-mini` during its 2026-08-28 refresh.

**`MindNode Classic` is a different application**, not a naming variant: id
`1289197285`, only on `macbook-2019`. The `MindNode 2` / `MindNode` pair above
really is one app under two names, on the shared id `6446116532`. So a
name-keyed diff across the three hosts sees three MindNodes and can never
reconcile them.

The same generated-label drift affects `HP Smart` / `HP` (id `1474276998`) and
`Blurred` / `Blurred 2` (id `1497527363`). Brew Bundle restores `mas` apps by
id, so these names do not change the restored application. They are retained as
reported by each host and accepted explicitly in `.doctor-baseline`.

The lesson for anyone diffing these files: an id that differs across hosts is
usually a real difference in what is installed, and only a repeated id *within
one file* is a duplicate.

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
- `shell/`: The shell-neutral spec — env, PATH, aliases, tool hooks, described
  once for bash, zsh, fish and nushell. See `shell/README.md`
- `generated/`: `bin/generate-shell-config`'s output. **Committed, and never
  hand-edited** — `just lint drift` regenerates and fails if the tree moved
- `functions/`: Bash/zsh function definitions
- `bin/`: Custom utility scripts

### `generated/` is committed on purpose

Nothing depends on the generator at shell-startup time: a broken or missing
`bin/generate-shell-config` cannot stop a shell from starting, because the
files it produces are already on disk and symlinked. The generator is a
development tool, not a runtime dependency.

The cost is that the output can go stale, which is what the `drift` check
exists for. The four generated `config/fish/conf.d/*.fish` files are also why
`.gitignore` names the vendored fisher files individually instead of ignoring
those directories — see below.

### `~/.config/fish` is a directory symlink, so generated fish files are live

Anything written under `config/fish/conf.d/` takes effect on the next shell,
immediately, with no install step. There is no "added but not activated" state.

That is why `.gitignore` lists the fisher-installed files one by one rather than
ignoring `conf.d/`, `completions/` and `functions/` wholesale. Under the old
blanket rules a generated file was live on disk **and invisible to
`git status`** — which made the documented `git checkout` recovery a silent
no-op. Keep the rules narrow; when adding a fisher plugin, add its files there
alongside the `fish_plugins` line that installs them.

### Why `packages/` is at the root and not under `config/`

`install.conf.yaml:27-31` globs `config/*` into `~/.config/`. Anything added
under `config/` is therefore symlinked into the live configuration tree as a
side effect, whether or not it is configuration. Data files that only the
`bin/` scripts read belong outside it.

### Adding a `config/<tool>/` requires saying what installs the tool

The same glob has a second consequence: a directory added under `config/` is
**live configuration the moment it is committed**, whether or not anything in
this repository installs the tool it configures. Nothing checked that, and
classifying all 32 entries by hand turned up four with no installer at all —
`cship.toml` (the binary is at `~/.local/bin/cship`, put there by nobody),
`harper-ls` (Neovim's Mason, and nothing in `config/nvim` even references it),
`doom` (git-cloned by `setup.sh`) and `gh-dash` (a gh extension, so no Brewfile
will ever name it).

`bin/lib/config-owners.manifest` records the answer for each entry, and
`just lint owners` asserts it covers `config/` in **both** directions: every
entry has a row, every row has an entry. That is a forcing function rather than
a record — a new directory fails the build until somebody says what provides its
tool, and `orphan` is a legitimate answer that then stays visible instead of
being rediscovered years later.

It is *not* a check that the tool is installed right now. That is per-host and
changes under you; `bin/dotfiles-doctor` answers it at runtime, reading this
file. Thirteen entries are in both a Brewfile and `config/mise/mise.toml`; the
manifest records which is *meant* to win — mise, since SI-118 — and doctor
reports the overlap rather than the file pretending it is fine.

A row may also carry an optional fifth field naming the hosts it applies to, so
that a tool belonging to one machine is not reported as missing on the others
(SI-125). `borders` and `wezterm` are the two: installed on `macbook-2019` by
design, and until the field existed they were permanent findings on the other
two. Absent means every host, which is why thirty of the thirty-two rows are
unchanged. `just lint owners` rejects a hostname with no file in `homebrew/`,
since a typo would disable the check everywhere instead of nowhere.

This is the third data file both a `bin/` script and a lint check read, after
`packages/` and `bin/lib/preferences.manifest`. All three exist for the same
reason: a list that lives in one place is reviewable in a diff, and the copies
that preceded them had all drifted.

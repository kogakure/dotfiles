# Troubleshooting

What each `bin/dotfiles-doctor` finding means, and what to do about it.

`just doctor` **reports**. It is read-only and structurally so: it calls `run`
nowhere, writes nothing under `$HOME` or the repository, and its single write is
`bin/generate-shell-config` into a `mktemp` directory outside both. `just lint
unit` and CI both hold it to that. `just clean` **repairs**, and only the two
things that can be repaired safely — dangling symlinks and tmux plugins
`tmux.conf` no longer names. It is dry-run by default, and `--apply` is read
from argv only, never from the `DOTFILES_*` environment channel. See
[commands.md](commands.md) for the invocations.

**A non-zero exit is not breakage.** Doctor exits 1 whenever it found anything,
so that it can gate a script; the findings are the backlog, not a fault in the
tool. Several of them are host-specific and expected on one machine and not
another, and those are called out below.

Default output is one line per finding. `--verbose` adds the evidence behind
each — the diff, the package list, the `mise config ls` table — and also prints
context that is deliberately *not* a finding, such as the brew/mise overlaps
nothing can remove. Run a subset by name: `just doctor brewfile mise`.

```bash
just doctor                    # every check, read-only
just doctor --verbose          # with the evidence
just doctor mise runtimes      # a subset
just clean                     # print a removal plan
just clean --apply             # remove, asking first
```

The checks run in this order: `links`, `brewfile`, `packages`, `binaries`,
`mise`, `runtimes`, `shells`, `generated`, `plugins`, `submodule`.

## `links`

Are there dangling symlinks in the directories this repository links into, and
did every link `install.conf.yaml` declares actually land?

This is the mirror of `dotfiles-lint`'s `yaml` check. That one validates the
link *source* exists in the repository; this validates the other end — that the
destination under `$HOME` exists, is a symlink, and was created. A source can be
perfectly present while nobody has run `./install`.

The scan covers `$HOME`, `$HOME/.config`, `$HOME/.gnupg` and `$HOME/.warp` at
depth 1 — the four directories `install.conf.yaml` lists under `clean:`. With
`~` alone, deleting a `config/*` entry left a dangling link in `~/.config`
forever.

**`dangling symlink: <path>`**
A symlink whose target no longer exists, usually left behind by a `config/`
entry that was renamed or deleted. This is one of the two findings `clean`
repairs:

```bash
just clean            # see the plan
just clean --apply    # rm -f each named symlink
```

The removal is `rm -f` against one named symlink, never recursive: the target is
gone by definition, so it unlinks a name and can destroy no content.

**`not linked: <path>`**
`install.conf.yaml` declares this destination and nothing is there. Nobody has
run dotbot since the entry was added.

```bash
just link             # ./install
just check-links      # ./install --dry-run first, if you want to look
```

**`not a symlink: <path>`**
A real file is sitting where the link should be, shadowing it. Dotbot will not
overwrite it. Move it aside and relink:

```bash
mv ~/.config/<thing> ~/.config/<thing>.bak
just link
```

**`could not read the link table out of install.conf.yaml`**
`yq` parsed the file to nothing. Either the YAML is malformed or the `link:`
section moved. `just lint yaml` is the check that names the problem.

The check also reports **`yq is not installed; the install.conf.yaml half was
not checked`** as a skip rather than a finding. The dangling-symlink half still
ran; only the "did every declared link land" half was silently unavailable.
`yq` is pinned in `config/mise/mise.toml`, so `mise install` supplies it.

## `brewfile`

Is this host's Brewfile satisfied, and do the three host files agree with each
other?

Skipped entirely when `brew` is not installed.

**`no Brewfile for host '<host>'`**
A hard failure, not a skip. `homebrew/$(hostname -s)` does not exist. On macOS
`hostname` returns the Bonjour name, which changes with the network — `.local`,
`.fritz.box` — and a fresh Mac reports something like `Mac.local`. `--verbose`
lists the hosts that do have a file.

```bash
sudo scutil --set HostName mac-mini    # the permanent fix
DOTFILES_HOST=mac-mini just doctor     # a one-off override
```

**`N package(s) in the Brewfile are not installed`**
From `brew bundle check --no-upgrade --verbose --file homebrew/<host>`.
`--verbose` names each one under `just doctor --verbose`.

```bash
./bin/homebrew-restore --dry-run   # what it would install
./bin/homebrew-restore             # install it
```

`--no-upgrade` is load-bearing rather than tidiness. Without it, `brew bundle
check` reports every merely **outdated** package as needing to be installed or
updated — 40+ lines on `macbook-m5-pro`, including `mise`, which is plainly
installed. That is indistinguishable from real drift, so the check gets ignored.
If you run `brew bundle check` by hand, pass the flag; and remember that its own
wording, "needs to be installed or updated", covers outdated as well as absent.

**`N inconsistency(ies) across the host Brewfiles`**
Not about this machine. Three analysers read `homebrew/*` — every host file, not
just yours — because a name that disagrees across machines is invisible from
inside either one:

| Reported as | Means |
| --- | --- |
| `mas "<name>" has several ids` | one app re-listed under a new App Store ID while the old entry stayed |
| `mas id <n> has several names` | the same app dumped under different names on two hosts, which defeats any name-keyed diff |
| `brew "<name>" is spelled several ways` | bare on one host, tap-qualified on another — the same package, invisible to a line-by-line comparison |
| `tap "<name>" is served from <owner>` | a tap pinned to a URL whose owner is not the tap's own, left over from a rename |

All four are **machine state, not file content**. The Brewfiles are `brew bundle
dump` output and are rewritten whole on every `bin/update`, so editing one fixes
nothing — the next dump on that host puts it back. Fix it on the host named in
the `--verbose` output, then re-dump:

```bash
# on the host in question, e.g. remove the stale duplicate app or re-tap
./bin/homebrew-backup
```

The known instances are enumerated in [architecture.md](architecture.md).

## `packages`

Is the tool behind each `config/` entry actually installed on this host?

Driven by `bin/lib/config-owners.manifest`, which is what lets it cover
mise-provided tools and gh extensions rather than only formulae. Every entry
under `config/` needs a row there — `just lint owners` fails in both directions,
so a new directory blocks the build until somebody says what provides its tool.
`orphan` is a legitimate answer. The manifest records what is *meant* to provide
each tool; this check answers whether it is here *now*, which is per-host and
changes under you.

### An entry can be scoped to particular machines

A row may carry an optional fifth field naming the hosts it applies to:

```
borders|brew|felixkratz/formulae/borders|started via packages/services|macbook-2019
```

On any other host the entry is **not** checked, and appears under `--verbose`
as `declared for macbook-2019 only, not checked here`. Without the field, a
tool installed on one machine by design was reported as missing on the other
two on every run, forever — a check telling you to fix what is not broken, and
the fastest way to train yourself to ignore it (SI-125).

Reach for it only when the tool genuinely belongs to particular machines. If
the answer is "it should be here and is not", that is a finding, not a scope.
`just lint owners` rejects a hostname with no file in `homebrew/`, because a
typo would silently disable the check on *every* host.

**`config/<entry> is here but brew has no '<name>'`**
The manifest says a formula or cask provides it and `brew list` does not show
it.

```bash
brew install <name>
./bin/homebrew-backup    # so the Brewfile records it
```

**`config/<entry> is here but mise cannot resolve '<name>'`**
Declared as mise-provided and `mise where <name>` fails.

```bash
mise install
```

The check uses `mise where` on the **tool** name, not `mise which` on a binary
name, because the binary is often not the tool: the `neovim` tool installs
`nvim`, `ripgrep` installs `rg`, `superfile` installs `spf`. It also retries
against backend-addressed keys — `cargo:atuin` where the aqua `atuin` entry is
skipped — so an arch-split tool on Intel is not reported as broken.

**`config/<entry> is here but the gh extension '<provider>' is not installed`**

```bash
gh extension install <provider>
```

Add it to `packages/gh-extensions` too if it is missing there, or the next fresh
machine comes up without it.

**`config/<entry> has no provider at all`**
The manifest row says `orphan`: nothing in this repository installs the tool and
nothing is expected to. This is a **standing, expected finding**, not a
regression. It stays visible on purpose — the alternative is rediscovering it
years later. Fixing it means either giving the tool a real provider (a Brewfile
entry, a mise pin) and updating the manifest row, or deleting the `config/`
directory in a reviewed commit.

**`config/<entry> is configured but nothing here installs '<provider>'`**
The row says `manual`: the tool is present on some machine because a human put
it there. Reproducible on a fresh machine only if you remember to do it by hand,
which is what the finding is telling you. Same two exits as `orphan`.

**`bin/lib/config-owners.manifest is missing`**
The check cannot run at all. Restore the file from git.

Rows whose kind is `setup`, `mason` or `fisher` are not checked — the tool is
provided outside the package managers — and are shown only under `--verbose`.

## `binaries`

Does every command `config/git/config` names unconditionally resolve on this
host?

**`config/git/config runs '<cmd>', which is not on PATH`**
The list is derived from the file rather than hand-maintained, reading the
`pager`, `diff` and `diffFilter` settings. Those references have no guard, so
`pager = hunk pager` on a host without `hunk` breaks every `git log` and `git
diff`. Install the tool, by whichever route `config-owners.manifest` names for
it:

```bash
mise install        # hunk and delta are mise tools
brew install <cmd>  # if the manifest says brew
```

Guarded references — the tool hooks in `shell/hooks.spec`, which test for the
binary before initialising it — are deliberately not checked here. A missing
one is not breakage.

## `mise`

One config in effect, every declared tool resolving from outside the repository,
and no unexplained double provision.

Skipped entirely when `mise` is not installed.

**`mise cannot resolve '<tool>' from outside the repository`**
The SI-118 failure class. A tool declared in a project-local mise config
resolves only while the cwd is inside that project; its shim then fails in every
script, cron job and `ssh host cmd`. The probe runs `mise where <tool>` from
`$TMPDIR` for exactly that reason — a pass means "resolves from here", not
"exists on disk somewhere".

```bash
mise install     # if it is simply not installed yet
```

If `mise install` does not fix it, the tool is being declared somewhere other
than `config/mise/mise.toml` — see the next finding.

The four arch-split tools (`atuin`, `delta`, `fd`, `pnpm`) are exempt when mise
agrees they are inactive here: each is declared twice, once per architecture,
and mise skips the entry whose `os/arch` pair does not match the host. The Intel
half is *expected* to be absent on Apple Silicon and vice versa. An
unconditional tool that does not resolve is still a finding.

**`N mise configs are in effect, not one`**
More than one config means two answers to "which version", and which you get
depends on where you are standing. `--verbose` prints `mise config ls` so you
can see which files. Counted from `mise config ls -J`, so it sees
`.tool-versions` as well as `.toml` — the file that actually caused this was an
untracked `~/.dotfiles/.tool-versions` that no git status and no CI run could
see.

Remove the extra config. There should be exactly one, `~/.config/mise/mise.toml`,
symlinked from `config/mise/mise.toml`; the file's own header says why a
project-local one is a trap, and `just lint` rejects one appearing in the
checkout.

**`N tool(s) are provided by both brew and mise`**
Which one you get depends on `PATH` order, so a script and an interactive shell
can disagree. mise wins by default since SI-118 — its shims are first in
`shell/path.spec` — so the repair is to remove brew's copy:

```bash
brew uninstall <formula>
./bin/homebrew-backup
```

The re-dump is **required**. Without it the Brewfile still names the formula,
and the next `bin/homebrew-restore` or `setup.sh --only packages` reinstalls it.
For the same reason, do not run `bin/homebrew-restore` between the uninstall and
the backup.

Since SI-121 the check splits the overlaps. Only formulae that **no other
installed formula depends on** are a finding, because those are the ones `brew
uninstall` will actually remove. The rest — brew's own copies of `node`, `ruby`,
`lua`, `deno` and friends, held by `prettierd`, `asciidoctor`, `highlight`,
`yt-dlp` and the like — are shown under `--verbose` as context, labelled *held by
a dependent formula*. They are not removable, not a decision anyone made, and
not actionable. The mise shims still come first, so the pinned copy wins
regardless; that matters most for `node` and `ruby`, where the pins are
deliberately older than brew's.

## `runtimes`

How many things provide `node`, and how many provide `rust`?

**`node has N providers: <list>`**
Any of `volta`, `mise` and `brew`. Which one wins depends on `PATH` order, so a
script and a shell can disagree; `--verbose` shows what `node` currently
resolves to.

volta is the usual culprit, and it is not going away on its own: it is in all
three Brewfiles, in `shell/env.spec` and in `shell/path.spec`, so every machine
has it. `docs/environment.md` described it as "legacy, being phased out" for
years, which was never true and was corrected in SI-86.

This is **flagged rather than fixed on purpose**: unwinding it is a migration
across three machines, not an edit. Expect the finding on every host, and treat
it as a standing backlog item rather than something to clear in passing.

**`rust has N providers: <list>`**
Added in SI-123. Any of `rustup`, `mise` and `brew`. The declared owner is
**rustup** — `config/mise/mise.toml` deliberately does not declare `rust`,
because mise's rust backend only drives rustup anyway, pinning the active
toolchain via `RUSTUP_TOOLCHAIN` in the shims while rustup's own default goes
silently stale underneath. That is how `macbook-2019` ended up on a year-old
nightly, which then broke `mise install` for the `cargo:` entries that compile
against whatever `rustc` resolves.

One owner instead:

```bash
rustup default stable
```

and drop the other provider — remove the mise `rust` declaration, or `brew
uninstall rust` followed by `./bin/homebrew-backup`. `bin/update`'s `rust` step
keeps rustup current with `rustup update`.

rustup is detected by its install location (`~/.cargo/bin/rustup`) rather than
by `have rustup`, because a mise-provided rust ships a rustup *shim* that would
make one provider look like two.

## `shells`

Is `fish` listed in `/etc/shells` exactly once?

Read-only and without `sudo`: the check diffs the current file against what
`shells_file_desired` would write. Skipped when `fish` is not installed or
`/etc/shells` is not readable.

**`/etc/shells lists <path> N times`**
`setup.sh` appended the fish path on every run until SI-83, and four entries had
accumulated across three machines. The repair rewrites the whole file rather
than appending, which is what makes it idempotent:

```bash
./setup.sh --only shell_default
```

`shell_default` changes the login shell, so it is not on the list of steps that
are casually safe to `--only`. Editing `/etc/shells` by hand to remove the
duplicate lines is the smaller change if that is all you want.

**`/etc/shells is not what setup.sh would write`**
Reported when the count is exactly one but the file still differs — in practice,
the fish entry is missing from a file that names some other path for it, or the
content diverged some other way. Same repair.

## `generated`

Is the committed shell config current with `shell/*.spec`?

The generator is run into a `mktemp` directory and the result diffed, rather
than regenerated in place. `just lint drift` does regenerate in place — it is
allowed to write, and only a real run proves the point — but a doctor may not,
so this asks the same question read-only.

**`the generated shell config is stale`**
Somebody edited a spec and did not regenerate, or hand-edited a generated file.
`--verbose` prints the diff.

```bash
just generate
git add shell/ generated/ config/fish/conf.d config/nushell/env.nu
```

Commit **both** the spec and the output. `just lint drift` fails if you commit
one without the other, so a spec edit that was never regenerated cannot ship.

Never hand-edit `generated/**`, `config/fish/conf.d/00-env.fish`,
`10-path.fish`, `20-aliases.fish` or `config/nushell/env.nu`. Each carries a
`DO NOT EDIT` header and the next `just lint` overwrites it.
`config/fish/config.fish` is fish-only concerns and stays hand-written.

**`bin/generate-shell-config failed`**
The generator itself errored. Run it directly to see why:

```bash
bin/generate-shell-config --dry-run
```

**`could not create a temporary directory`**
`mktemp -d` failed under `$TMPDIR`. A full disk or a `TMPDIR` pointing somewhere
that does not exist.

A skip — **`bin/generate-shell-config is not executable`** — means the file lost
its permission bit; `chmod +x bin/generate-shell-config`.

## `plugins`

Are the tmux plugins `config/tmux/tmux.conf` declares actually installed?

**tpm installs into `~/.config/tmux/plugins`, not `~/.tmux/plugins`** — which,
via the directory symlink, is `config/tmux/plugins` in this repository. tpm is
XDG-aware: it uses `$XDG_CONFIG_HOME/tmux/plugins/` whenever
`$XDG_CONFIG_HOME/tmux/tmux.conf` exists, and `install.conf.yaml` globs
`config/*` into `~/.config/`, so that file exists on every machine here.
`~/.tmux/plugins/` therefore holds tpm itself and nothing else, and that is
correct rather than a symptom.

Doctor resolves the directory with `tmux_plugin_path` in `bin/lib/tmux.sh`,
which replicates tpm's rule rather than asking the server. The authoritative
answer is `tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH`, but reaching it
costs a `tmux start-server` when none is running — a mutation, which this
script may not make. `bin/dotfiles-clean` uses the same function, so the two
cannot disagree about which directory they are talking about.

Until SI-124 both assumed `~/.tmux/plugins`, so the check reported **all**
seventeen declared plugins as missing on every host and advised an installer
that would have cloned a second, unused copy into the wrong place.

**`N tmux plugin(s) declared but not installed`**

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

or `./setup.sh --only tmux_plugins`, which is one of the re-runnable steps.
The finding names the resolved directory under `--verbose`, so a wrong answer
is visible rather than implied.

`--verbose` additionally prints the short SHA of every installed plugin. That is
not a finding — it is the record that makes a breakage diagnosable after the
fact. `zsh_plugins.txt`, `config/fish/fish_plugins` and tpm all follow upstream
HEAD with no lockfile, unlike `config/nvim/lazy-lock.json`.

The opposite direction — an installed plugin that
`tmux.conf` no longer names — is not doctor's; tpm installs but never
uninstalls, so it is the second thing `clean` repairs:

```bash
just clean            # see which
just clean --apply    # remove them
```

## `submodule`

Is `private/` initialised, and is it carrying uncommitted work?

Queried with plain `git` rather than through `private_gate`, which logs and
exports `DOTFILES_PRIVATE_GATE` — a doctor must not change its caller's
environment or the decisions a later backup makes.

**`private/ is not a git checkout`**

```bash
git submodule update --init --recursive
```

Expected, and not fixable, anywhere the submodule is not reachable — CI leaves
it uninitialised deliberately, which is why `dotfiles-lint` excludes `private/*`.

**`private/ has N uncommitted change(s)`**
Almost always this machine's own backups: `bin/dotfiles-backup` writes into
`private/` and does not commit. `--verbose` prints the `git status --porcelain`
lines.

```bash
git -C private status
git -C private add -A && git -C private commit -m "chore: backup"
git -C private push
```

Commit them so the other machines see them. This matters more than it looks:
`private/claude/<profile>/` and `private/codex/<profile>/` are keyed on the
profile only, not the host, so two machines on the same profile write to the
same directory. Uncommitted work there is work the other machine cannot see —
and is the reason no backup prunes a destination whose source is missing
locally.

## What `clean` will not touch

`bin/dotfiles-clean` also **reports** a short list of artefacts that look dead —
`default-gems`, `default-npm-packages`, `default-python-packages`,
`warp/settings.toml`, `config/wezterm`, `config/cship.toml` — and removes none of
them. Each is dead on the evidence of reading it rather than of a check, and "I
could not find a use for it" is not a reason for a script to delete your files.
Removing one is a reviewable commit. A path that no longer exists is not
printed, so the list shrinks itself as the removals happen.

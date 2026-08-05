# omp sandbox kit

A [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) `kind: sandbox`
kit that teaches `sbx` an `omp` agent — [omp](https://omp.sh) ("oh-my-pi",
[can1357/oh-my-pi](https://github.com/can1357/oh-my-pi)), a batteries-included
fork of the same [pi-mono](https://github.com/badlogic/pi-mono) lineage as
the sibling `pi` kit — which has no built-in support in Docker Sandboxes.

Launch it with `sbxa omp` (herdr-aware, see
`config/fish/functions/sbxa.fish`) or `bin/sbx-omp` directly rather than
calling `sbx` yourself — the wrapper seeds the sandbox with the host's omp
logins and config after creation, which a bare `sbx run --kit` cannot do. It
also `exec`s the final `sbx run` with argv0 renamed to `omp`, the same trick
`sbxa` and `bin/sbx-pi` use, so herdr detects the pane as omp instead of a
bare `sbx` process.

## Why no `credentials:`/`serviceAuth` block

omp on this host authenticates via OAuth, stored in a SQLite database
(`~/.omp/agent/agent.db`, `auth_credentials` table — currently `openai-codex`,
`anthropic`, `xai-oauth`), not static API keys. Docker Sandboxes' kit
credential system (`credentials.sources` + `network.serviceAuth`) is built
for placeholder-substituted API keys and would also force TLS interception
on the provider domains, which breaks OAuth token exchanges. So instead:

- `caps.network.allow` plainly allowlists the provider and auth endpoints
  (no interception, no substitution).
- `bin/sbx-omp` checkpoints the host's SQLite WAL
  (`PRAGMA wal_checkpoint(FULL)`) so a plain file copy of `agent.db` is
  complete and consistent, then copies `agent.db` and `config.yml` into the
  sandbox with `sbx cp` right after creation, then reclaims ownership with
  `sbx exec -u root <name> -- chown -R agent:agent /home/agent/.omp` (`sbx
  cp` preserves host ownership/mode, so without this the sandbox's uid-1000
  `agent` user can't read them).

Not copied: `models.db*` (provider/model catalog cache — omp refreshes it
itself), `history.db*` (usage stats), `sessions/`, `terminal-sessions/`,
`last-changelog-version`, and everything under
`~/.omp/{logs,natives,run,gpu_cache.json,install-id}` (host-specific runtime
and platform state — `natives/` in particular holds a `darwin-arm64` native
addon, useless inside a Linux container).

## No dedicated herdr detection manifest (yet)

Unlike `pi`, herdr ships no `omp.toml` detection manifest
(`herdr agent explain --agent omp` → `manifest: none unknown`). `omp` is
still one of herdr's recognized agent names, so the argv0 rename gets it
into `herdr agent list` with idle-fallback tracking
(`fallback_reason: default_known_agent_idle_fallback`) — but it won't show
`working`/`blocked` state transitions the way `pi` does via its manifest's
screen rules. herdr's manifests are all remote-fetched into
`~/.local/state/herdr/agent-detection/remote/`; no local-override mechanism
was found, so there's currently nothing to add on the dotfiles side to fix
this — it depends on herdr shipping one.

## Adding a model provider

1. Add its API/auth domains to `spec.yaml`'s `caps.network.allow`.
2. Re-create the sandbox (kit changes only apply at creation —
   `sbx rm <name>` first) or add the kit to a running one with
   `sbx kit add <name> ./config/sbx/kits/omp`.

## Refreshing auth

`bin/sbx-omp` only copies `agent.db`/`config.yml` when it creates a sandbox.
After logging in to a new provider on the host (or if a long-running
sandbox's OAuth token expires and omp can't refresh it), re-copy manually:

```console
sqlite3 ~/.omp/agent/agent.db 'PRAGMA wal_checkpoint(FULL);'
sbx cp ~/.omp/agent/agent.db <name>:/home/agent/.omp/agent/agent.db
sbx exec -u root <name> -- chown -R agent:agent /home/agent/.omp
```

## Why no Node/compiler install step

Unlike `pi` (an npm package that builds native modules on install), omp
ships as a single self-contained platform binary via GitHub Releases (see
the `can1357/tap/omp` Homebrew formula — it's a straight
`bin.install Dir["omp-*"].first => "omp"`, no build step). The kit's install
command just detects the container's arch and downloads the matching
`omp-linux-<arch>` release asset directly — no base image changes needed.

## Debugging

```console
sbx kit validate ./config/sbx/kits/omp
sbx kit inspect ./config/sbx/kits/omp
sbx policy log          # see blocked network requests
sbx exec <name> -- omp --version
```

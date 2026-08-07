# pi sandbox kit

A [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) `kind: sandbox`
kit that teaches `sbx` a `pi` agent — the [Pi coding
agent](https://github.com/badlogic/pi-mono) (`@earendil-works/pi-coding-agent`),
which has no built-in support in Docker Sandboxes.

Launch it with `sbxa pi` (herdr-aware, see `config/fish/functions/sbxa.fish`)
or `bin/sbx-pi` directly rather than calling `sbx` yourself — the wrapper
seeds the sandbox with the host's pi auth and config after creation, which a
bare `sbx run --kit` cannot do. It also `exec`s the final `sbx run` with
argv0 renamed to `pi`, the same trick `sbxa` uses for built-in agents, so
herdr detects the pane as pi instead of a bare `sbx` process. It also mounts
`~/Downloads` read-only alongside the workspace, so images dropped there on the
host are readable by the agent.

## Why no `credentials:`/`serviceAuth` block

pi on this host authenticates via OAuth (`~/.pi/agent/auth.json`: access +
refresh tokens per provider), not static API keys. Docker Sandboxes' kit
credential system (`credentials.sources` + `network.serviceAuth`) is built
for placeholder-substituted API keys and would also force TLS interception
on the provider domains, which breaks OAuth token exchanges. So instead:

- `caps.network.allow` plainly allowlists the provider and auth endpoints
  (no interception, no substitution).
- `bin/sbx-pi` copies `~/.pi/agent/auth.json` into the sandbox with `sbx cp`
  right after creation, then reclaims ownership with
  `sbx exec -u root <name> -- chown -R agent:agent /home/agent/.pi`
  (`sbx cp` preserves host ownership/mode, and `auth.json` is `0600` on the
  host, so without this the sandbox's uid-1000 `agent` user can't read it).

## Adding a model provider

1. Add its API/auth domains to `spec.yaml`'s `caps.network.allow`.
2. Re-create the sandbox (kit changes only apply at creation —
   `sbx rm <name>` first) or add the kit to a running one with
   `sbx kit add <name> ./config/sbx/kits/pi`.

## Refreshing auth

`bin/sbx-pi` only copies `auth.json` when it creates a sandbox. If a
long-running sandbox's OAuth token expires and pi can't refresh it itself
(needs `auth.openai.com` / `*.x.ai` reachable, already allowlisted), re-copy
it manually:

```console
sbx cp ~/.pi/agent/auth.json <name>:/home/agent/.pi/agent/
sbx exec -u root <name> -- chown -R agent:agent /home/agent/.pi
```

## Why the C/C++ toolchain install step

`docker/sandbox-templates:shell-docker` ships Node 22 but no compiler.
pi's `settings.json` `packages` list (e.g. `pi-agent-browser-native`) pulls
in native modules like `node-pty` that `npm install` builds from source on
first run — without `build-essential` (specifically `g++`/`make`) that
build fails and pi never starts. The kit installs it conditionally, same
pattern as the Node.js check.

## Debugging

```console
sbx kit validate ./config/sbx/kits/pi
sbx kit inspect ./config/sbx/kits/pi
sbx policy log          # see blocked network requests
sbx exec <name> -- pi --version
```

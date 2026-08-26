# `shell/` — the shell-neutral spec

Four data files describing environment, `PATH`, aliases and tool hooks **once**.
`bin/generate-shell-config` reads them and emits the bash/zsh/fish/nushell forms
into `generated/` and `config/fish/conf.d/`.

Generated output is **committed**, so nothing depends on the generator at shell
startup, and `bin/dotfiles-lint drift` fails if it is stale.

```
shell/env.spec      environment variables
shell/path.spec     PATH, in order, front to back
shell/aliases.spec  aliases
shell/hooks.spec    tool init hooks, per dialect
```

## Common line syntax

Blank lines and `#` comments are ignored. A line may carry a leading guard:

```
@darwin  SSH_AUTH_SOCK = …
         KEYTIMEOUT = 1
```

| Guard | True when |
| --- | --- |
| `@darwin` | `uname` is `Darwin` |
| `@linux` | `uname` is `Linux` |
| `@brew` | a Homebrew prefix was found (`$BREW_PREFIX` is non-empty) |
| `@cmd:NAME` | `NAME` is on `PATH` |
| `@dir:PATH` | `PATH` is a directory |
| `@interactive` | the shell is interactive |

Guards are emitted as **runtime conditionals**, never resolved when the
generator runs. That is what lets one committed file be byte-identical on macOS
and on Linux — which CI checks, because it runs the drift gate on both.

## Substitutions

| Token | Meaning |
| --- | --- |
| `$HOME` | passed through verbatim to every dialect |
| `$BREW_PREFIX` | the Homebrew prefix, resolved at runtime (`/opt/homebrew` or `/usr/local`) |
| `$BREW_REPO` | the Homebrew repository (`$BREW_PREFIX`, but `/usr/local/Homebrew` under `/usr/local`) |
| `$(cmd)` | command substitution; rewritten to `(cmd)` for fish |
| `%NAME` | a spec-local macro, defined by `%NAME = value` and expanded at generation time. Never emitted |

## `env.spec`

```
[@guard] NAME = value        export NAME
[@guard] +NAME = value       prepend `value` to the colon-list NAME (e.g. MANPATH)
%NAME = value                generation-time macro
```

## `path.spec`

One directory per line, **in final order, front to back**. A guard may precede it.

The emitted code adds an entry only if the directory exists and is not already
present, then appends whatever it inherited from the parent process. So the
result is idempotent under nesting — which is the bug this replaces: `config.fish`
used unguarded `set -x PATH $PATH …`, and a fish shell inside a fish shell
carried 15 duplicated entries.

## `aliases.spec`

```
[@guard] name = command
```

Emitted as `alias name='command'` for bash/zsh and `alias name 'command'` for
fish. Aliases may **not** use positional parameters — `alias ia='open $1 …'` was
a live shellcheck `SC2142` error and silently relied on `$1` expanding to
nothing. Write the command so the shell's own argument append does the work.

## `hooks.spec`

Block per tool. `bash`, `zsh`, `fish` and `nu` lines are the literal init
command for that dialect; a dialect with no line gets no hook.

```
tool mise
guard @cmd:mise
bash eval "$(mise activate bash)"
zsh  eval "$(mise activate zsh)"
fish mise activate fish | source
```

Every hook is emitted inside an interactive guard, because that is what
`generated/hooks.bash` / `.zsh` and `conf.d/30-hooks.fish` are for. Anything a
non-interactive shell needs belongs in `env.spec` or `path.spec` instead — that
is why mise's *shims* are a path entry while `mise activate` is a hook.

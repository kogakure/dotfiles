function sbxa --description "Run an agent in a Docker sandbox so herdr detects it"
    if test (count $argv) -eq 0
        echo "usage: sbxa <agent> [PATH...] [sbx flags] [-- AGENT_ARGS...]" >&2
        echo "       sbxa claude" >&2
        echo "       sbxa codex . ~/Notes:ro" >&2
        echo "       sbxa claude -- --continue" >&2
        echo "       sbxa pi   # custom kit, see config/sbx/kits/pi" >&2
        return 1
    end

    set -l agent $argv[1]

    if string match -qr '^-' -- $agent
        echo "sbxa: first argument must be the agent name (claude, codex, ...)" >&2
        return 1
    end

    # herdr identifies the agent occupying a pane from the foreground process
    # argv0, matched against its detection manifests. Inside a sandbox that
    # process is `sbx`, so herdr sees no agent. Renaming argv0 to the agent name
    # restores identification; state (idle/working/blocked) then comes from
    # herdr's screen rules, which read the container's TUI in the pane as usual.

    # Custom sandboxes (kits that don't map to a built-in `sbx run` agent, e.g.
    # pi) need more than a renamed `sbx run` — creation, config seeding, etc.
    # That logic lives in a dedicated launcher on PATH named "sbx-<agent>"
    # (see bin/sbx-pi), which does its own argv0 rename via `exec -a`. Prefer
    # it when present so dropping in a new bin/sbx-<agent> script is enough to
    # teach sbxa a new custom sandbox — no edits here required.
    set -l launcher "sbx-$agent"
    if command -v $launcher >/dev/null 2>&1
        exec $launcher $argv[2..-1]
    end

    # A kit-only custom sandbox (no launcher needed, just `--kit`).
    set -l kit_spec "$HOME/.dotfiles/config/sbx/kits/$agent/spec.yaml"
    if test -f $kit_spec
        # fish's exec has no -a, hence the bash hop.
        bash -c 'name=$1; kit=$2; shift 2; exec -a "$name" sbx run "$name" --kit "$kit" "$@"' bash $agent (dirname $kit_spec) $argv[2..-1]
        return $status
    end

    # Built-in sbx agent: fish's exec has no -a, hence the bash hop.
    bash -c 'name=$1; shift; exec -a "$name" sbx run "$@"' bash $agent $argv
end

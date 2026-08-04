function sbxa --description "Run an agent in a Docker sandbox so herdr detects it"
    if test (count $argv) -eq 0
        echo "usage: sbxa <agent> [PATH...] [sbx flags] [-- AGENT_ARGS...]" >&2
        echo "       sbxa claude" >&2
        echo "       sbxa codex . ~/Notes:ro" >&2
        echo "       sbxa claude -- --continue" >&2
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
    # fish's exec has no -a, hence the bash hop.
    bash -c 'name=$1; shift; exec -a "$name" sbx run "$@"' bash $agent $argv
end

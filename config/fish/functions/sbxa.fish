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

    # The remaining dispatch paths hand the arguments straight to `sbx run`, so
    # this is where ~/Downloads gets mounted (the sbx-<agent> launchers above do
    # it themselves). It is where screenshots and downloaded assets land, so the
    # agent almost always wants to read from it; read-only so it can never
    # delete or overwrite anything there.
    #
    # Note this only applies when `sbx run` CREATES the sandbox — extra paths
    # are ignored when re-attaching to an existing one, so a sandbox that
    # already exists needs `sbx rm <name>` before it picks the mount up.
    #
    # Splitting the args is unavoidable: paths have to land before the `--`
    # separator, agent args after it.
    set -l sbx_args
    set -l agent_args
    set -l have_sep 0
    set -l seen_sep 0
    # `sbx` flags that consume the next argument, which is therefore not a path.
    set -l value_flags --name --template -t --profile --publish -p --memory -m --cpus --deny-network --static-mcp
    set -l skip_next 0
    set -l path_count 0
    set -l has_downloads 0

    for a in $argv[2..-1]
        if test $seen_sep -eq 1
            set -a agent_args $a
            continue
        end
        if test "$a" = --
            set seen_sep 1
            set have_sep 1
            continue
        end
        set -a sbx_args $a
        if test $skip_next -eq 1
            set skip_next 0
        else if contains -- $a $value_flags
            set skip_next 1
        else if not string match -qr '^-' -- $a
            set path_count (math $path_count + 1)
            if string match -q "$HOME/Downloads" -- $a
                or string match -q "$HOME/Downloads:*" -- $a
                set has_downloads 1
            end
        end
    end

    # `sbx run` only defaults to the current directory when no path is given at
    # all, so adding Downloads to a bare invocation means spelling out `.` too.
    if test $path_count -eq 0
        set -a sbx_args .
    end
    if test $has_downloads -eq 0
        set -a sbx_args "$HOME/Downloads:ro"
    end

    set -l forward $sbx_args
    if test $have_sep -eq 1
        set forward $sbx_args -- $agent_args
    end

    # A kit-only custom sandbox (no launcher needed, just `--kit`).
    set -l kit_spec "$HOME/.dotfiles/config/sbx/kits/$agent/spec.yaml"
    if test -f $kit_spec
        # fish's exec has no -a, hence the bash hop.
        bash -c 'name=$1; kit=$2; shift 2; exec -a "$name" sbx run "$name" --kit "$kit" "$@"' bash $agent (dirname $kit_spec) $forward
        return $status
    end

    # Built-in sbx agent: fish's exec has no -a, hence the bash hop.
    bash -c 'name=$1; shift; exec -a "$name" sbx run "$name" "$@"' bash $agent $forward
end

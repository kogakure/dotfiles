function claude-mem
    set -l scripts (ls $HOME/.claude/plugins/cache/thedotmack/claude-mem/*/scripts/worker-service.cjs 2>/dev/null | sort -V)
    if test (count $scripts) -eq 0
        echo "claude-mem: plugin not found in ~/.claude/plugins/cache/thedotmack/claude-mem/" >&2
        return 1
    end
    bun $scripts[-1] $argv
end

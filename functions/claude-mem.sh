claude-mem() {
  local script
  script=$(ls "$HOME/.claude/plugins/cache/thedotmack/claude-mem/"*/scripts/worker-service.cjs 2>/dev/null | sort -V | tail -1)
  if [[ -z "$script" ]]; then
    echo "claude-mem: plugin not found in ~/.claude/plugins/cache/thedotmack/claude-mem/" >&2
    return 1
  fi
  bun "$script" "$@"
}

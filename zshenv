# Private secrets (optional, not in repo)
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

# Session variables
source "$HOME/.session-variables.sh"

# Only source this once
if [[ -z "$ZSH_SESSION_VARS_SOURCED" ]]; then
  export ZSH_SESSION_VARS_SOURCED=1
fi

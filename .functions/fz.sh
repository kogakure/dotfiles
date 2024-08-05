# Search z history with fzf

fz() {
    # Check if z is installed
    if ! command -v _z >/dev/null 2>&1; then
        echo "Error: z is not installed or not in PATH"
        return 1
    fi

    # If arguments are provided, use z directly
    if [ $# -gt 0 ]; then
        _z "$*" && return
    fi

    # Use fzf to select from z history
    local dir
    dir=$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' |
        fzf --height 40% --nth 1.. --reverse --inline-info +s --tac --query "${*##-* }" \
            --preview 'ls -l {}' \
            --preview-window right:50% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Press CTRL-/ to toggle preview window')

    # Change to the selected directory
    if [ -n "$dir" ]; then
        cd "$dir" || return 1
    fi
}

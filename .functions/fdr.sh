# fdr - cd to selected parent directory

fdr() {
    get_parent_dirs() {
        if [ -d "$1" ]; then
            echo "$1"
        else
            return
        fi

        if [ "$1" = "/" ]; then
            return
        else
            get_parent_dirs "$(dirname "$1")"
        fi
    }

    # Use command substitution to get the selected directory
    DIR=$(get_parent_dirs "$(realpath "${1:-$(pwd)}")" | tac | fzf-tmux)

    # Change to the selected directory if one was chosen
    if [ -n "$DIR" ]; then
        cd "$DIR" || return
    else
        echo "No directory selected."
    fi
}

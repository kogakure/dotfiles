# fhcd – Jump to home directory and search for directories

fhcd() {
    # Change to home directory
    cd "$HOME" || return

    # Change to subdirectory if provided
    if [ -n "$1" ] && [ -d "$1" ]; then
        cd "$1" || return
    fi

    # Find directories and use fzf for selection
    local dir
    dir=$(find . -type d | sed '1d; s|^\./||' | fzf --preview 'tree -C {} | head -50')

    # Change to selected directory if one was chosen
    if [ -n "$dir" ]; then
        cd "$dir" || return
    else
        echo "No directory selected. Staying in current directory."
    fi
}

# Determine size of a file or total size of a directory

fs() {
    # Check if 'du' supports the -b option
    if du -b /dev/null > /dev/null 2>&1; then
        arg="-sbh"
    else
        arg="-sh"
    fi

    # If arguments are provided, use them; otherwise, use current directory
    if [ $# -gt 0 ]; then
        du $arg -- "$@"
    else
        # Use find to handle hidden files and directories
        find . -maxdepth 1 -print0 | xargs -0 du $arg | sort -h
    fi
}

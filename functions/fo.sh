# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR

fo() {
    # Use process substitution to capture fzf output
    IFS=$'\n' read -r -d '' key file <<EOF
$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
EOF

    # Check if a file was selected
    if [ -n "$file" ]; then
        if [ "$key" = "ctrl-o" ]; then
            # Check which "open" command to use
            if command -v xdg-open > /dev/null 2>&1; then
                xdg-open "$file"  # For Linux
            elif command -v open > /dev/null 2>&1; then
                open "$file"  # For macOS
            else
                echo "No suitable 'open' command found."
            fi
        else
            ${EDITOR:-vim} "$file"
        fi
    fi
}

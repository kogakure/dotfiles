# fshow - git commit browser

fshow() {
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Define the git log format
    local log_format="%C(auto)%h%d %s %C(black)%C(bold)%cr"

    # Use git log to get the commit history and pipe it to fzf
    git log --graph --color=always --format="$log_format" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index \
            --bind=ctrl-s:toggle-sort \
            --bind=ctrl-d:preview-page-down \
            --bind=ctrl-u:preview-page-up \
            --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7,\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

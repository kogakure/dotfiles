# fcoc - checkout git commit

fcoc() {
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local commits commit

    # Get commits
    commits=$(git log --pretty=oneline --abbrev-commit --reverse) || return

    # Use fzf to select a commit
    commit=$(echo "$commits" | fzf --tac +s +m -e --preview 'git show --color=always {1}') || return

    # Extract the commit hash
    commit_hash=$(echo "$commit" | awk '{print $1}')

    # Checkout the selected commit
    if [ -n "$commit_hash" ]; then
        echo "Checking out commit: $commit_hash"
        git checkout "$commit_hash"
    else
        echo "No commit selected."
    fi
}

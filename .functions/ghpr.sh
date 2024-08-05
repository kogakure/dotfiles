# Search and preview GitHub pull requests

ghpr() {
    # Force GitHub CLI to use colors
    export GH_FORCE_TTY=100%

    # List pull requests and pipe to fzf for selection
    selected_pr=$(gh pr list | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 3)

    # Check if a PR was selected
    if [ -n "$selected_pr" ]; then
        # Extract the PR number and checkout
        pr_number=$(echo "$selected_pr" | awk '{print $1}')
        gh pr checkout "$pr_number"
    else
        echo "No pull request selected."
    fi
}

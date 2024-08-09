# fco - checkout git branch/tag

fco() {
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local tags branches target

    # Get tags
    tags=$(git tag | awk '{print "\033[31;1mtag\033[m\t" $1}') || return

    # Get branches
    branches=$(git branch --all | grep -v HEAD |
        sed "s/.* //" | sed "s#remotes/[^/]*/##" |
        sort -u | awk '{print "\033[34;1mbranch\033[m\t" $1}') || return

    # Combine tags and branches
    target=$( (echo "$tags"; echo "$branches") |
        fzf-tmux --no-hscroll --ansi +m -d "\t" -n 2 \
        --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | awk "{print \$2}")' \
        --preview-window right:60%) || return

    # Extract the branch or tag name and checkout
    local branch_or_tag
    branch_or_tag=$(echo "$target" | awk '{print $2}')

    echo "Checking out: $branch_or_tag"
    git checkout "$branch_or_tag"
}

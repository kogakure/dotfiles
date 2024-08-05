# fcd - cd into directory

fcd() {
    local dir
    dir=$(find . -type d | sed '1d; s|^\./||' | fzf --preview 'tree -C {} | head -50') && cd "$dir"
}

# Find in files with ripgrep and fzf and open on that line
# -> Works together with Vim Plugin bogado/file-line

frg() {
    pattern="${1:-.}"
    file_glob="${2:-*}"

    result=$(rg "$pattern" --line-number --glob "$file_glob" | fzf --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window '+{2}-/2')

    if [ -n "$result" ]; then
        file=$(echo "$result" | cut -d: -f1)
        line=$(echo "$result" | cut -d: -f2)

        if command -v nvim >/dev/null 2>&1; then
            nvim "+${line}" "$file"
        elif command -v vim >/dev/null 2>&1; then
            vim "+${line}" "$file"
        else
            echo "Neither neovim nor vim is installed."
        fi
    else
        echo "No file selected."
    fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe --description "Open the selected file with the default editor"
    set files (fzf-tmux --query=$argv --multi --select-1 --exit-0 | string split \n)

    if test -n "$files"
        $EDITOR $files; and true # This line is added to prevent failure when using "set -e" in shell.
    end
end

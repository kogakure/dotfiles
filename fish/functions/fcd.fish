function fcd --description "cd into directory"
    cd (find * -type d | fzf --preview 'tree -C {} | head -50')
end

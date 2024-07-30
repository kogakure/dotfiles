function fhcd --description "Jump to home directory and search for directories"
    cd $HOME
    cd (find * -type d | fzf --preview 'tree -C {} | head -50')
end

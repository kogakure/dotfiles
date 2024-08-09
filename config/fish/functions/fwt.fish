function fwt --description "Jump to Git worktree directory"
    cd (git worktree list | awk '{print $1}' | fzf)
end

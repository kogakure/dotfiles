function update --description "Updating Homebrew, Ruby, Python, Node.js, Neovim, and MacOS"
    sudo -v
    ~/.tmux/plugins/tpm/bin/update_plugins all
    gh extension upgrade --all
    nvim --headless "+Lazy! sync" +qa
    brew update && brew outdated && brew upgrade && brew cleanup
    sudo gem update --system && sudo gem update && gem cleanup all
    pip install --upgrade pip
    pip list -o --format columns | cut -d' ' -f1 | xargs -n1 pip install -U
    pnpm update -g
    fisher update
    sudo softwareupdate -i -a
end

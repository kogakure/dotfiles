function homebrewRestore --description "Install all Homebrew, Cask, Mac App Store, and WhaleBrew applications from a snapshot"
    switch $hostname
        case mac-mini
            brew bundle --file ~/.dotfiles/Brewfile
        case '*'
            brew bundle --file ~/.dotfiles/Brewfile-Work
    end
end

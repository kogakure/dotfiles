function homebrewBackup --description "Create a snapshot of all currently installed Homebrew, Cask, Mac App Store, and WhaleBrew installations"
    switch $hostname
        case mac-mini
            brew bundle dump --force --describe --file=~/.dotfiles/Brewfile
        case '*'
            brew bundle dump --force --describe --file=~/.dotfiles/Brewfile-Work
    end
end

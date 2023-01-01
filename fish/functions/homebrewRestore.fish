function homebrewRestore --description "Install all Homebrew, Cask, Mac App Store, and WhaleBrew applications from a snapshot"
  brew bundle --file ~/.dotfiles/Brewfile
end

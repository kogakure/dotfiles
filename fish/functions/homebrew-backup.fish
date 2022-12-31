function homebrewBackup --description "Create a snapshot of all currently installed Homebrew, Cask, Mac App Store, and WhaleBrew installations"
  cd ~/.dotfiles/
  brew bundle dump --describe -f
end

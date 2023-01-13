function update --description "Updating Homebrew, Ruby, Python, Node.js, Neovim, and MacOS"
  brew update && brew outdated && brew upgrade && brew cleanup
  sudo gem update --system && sudo gem update && gem cleanup all
  pip install --upgrade pip
  pip list -o --format columns | cut -d' ' -f1 | xargs -n1 pip install -U
  npm update npm -g
  npm update -g
  # nvim --headless "+Lazy! update" +qa
  sudo softwareupdate -i -a
end

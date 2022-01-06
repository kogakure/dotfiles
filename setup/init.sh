#!/bin/sh

# Install Xcode Developer Tools
xcode-select --install

# Install TMUX Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Installing Homebrew packages
source ./brew.sh

# Installing Homebrew Cask packages
source ./cask.sh

# Installing Node.js
source ./nvm.sh

# Installing global Node.js modules
source ./npm.sh

# Installing Python version manager
source ./python.sh

# Install current version of Ruby
source ./ruby.sh

# Install global Gems
source ./gem.sh

# Install Visual Studio Code Extensions
source ./vscode.sh

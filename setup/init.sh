#!/bin/sh

# Install Xcode Developer Tools
xcode-select --install

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

#!/bin/sh

echo "Setting up the Mac"
sudo -v

# Xcode Developer Tools
echo "Installing Xcode Developer Tools"
xcode-select --install

# TMUX Plugin Manager
echo "Installing TMUX Plugin Manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Homebrew
if test ! $(which brew); then
	echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew packages, Cask binaries and Mac App Store software
echo "Installing Homebrew packages, Cask binaries and Mac App Store software"
source ./brew.sh

# Direnv
echo "Installing Direnv"
source ./direnv.sh

# Node.js
echo "Installing Node.js"
source ./nodejs.sh

# Python
echo "Installing Python"
source ./python.sh

# Lua
echo "Installing Lua"
source ./lua.sh

# Rust
echo "Installing Rust"
source ./rust.sh

# Ruby
echo "Installing Ruby"
source ./ruby.sh

# Golang
echo "Installing Go"
source ./golang.sh

# GitHub CLI Extensions
echo "Installing GitHub CLI Extensions"
source ./github.sh

# Visual Studio Code Extensions
echo "Installing Visual Studio Code Extensions"
source ./vscode.sh

#!/bin/sh

echo "Setting up the Mac"
sudo -v

# Xcode Developer Tools
echo "Installing Xcode Developer Tools"
xcode-select --install

# Download wezterm.terminfo
curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -

# TMUX Plugin Manager
echo "Installing TMUX Plugin Manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fish Plugin Manager
echo "Installing Fish Plugin Manager"
source ./fisher.sh

# Homebrew
if test ! $(which brew); then
	echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install SSH keys Secure Enclave
brew install --cask secretive

# Homebrew packages, Cask binaries and Mac App Store software
echo "Installing Homebrew packages, Cask binaries and Mac App Store software"
source ./brew.sh

# Neovim
echo "Installing Neovim"
source ./neovim.sh

# Direnv
echo "Installing Direnv"
source ./direnv.sh

# Node.js
echo "Installing Node.js"
source ./nodejs.sh

# Deno
echo "Installing Deno"
source ./deno.sh

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

# MacOS Default Settings
echo "Restoring default settings for MacOS"
source ./macos.sh

# Install Themes
cd ~/.dotfiles/bat
bat cache --build
silicon --build-cache
cd ..

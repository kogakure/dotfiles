#!/bin/sh

echo "Setting up the Mac"
sudo -v

# Xcode Developer Tools
echo "Installing Xcode Developer Tools"
xcode-select --install

# TMUX Plugin Manager
echo "Installing TMUX Plugin Manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fish Plugin Manager
echo "Installing Fish Plugin Manager"
source ./fisher.sh

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

# MacOS Default Settings
echo "Restoring default settings for MacOS"
source ./macos.sh

# Install Themes
cd ~/.dotfiles/bat
bat cache --build
silicon --build-cache
cd ..

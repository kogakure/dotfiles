#!/bin/sh

echo "Setting up the Mac"
sudo -v

# Xcode Developer Tools
echo "Installing Xcode Developer Tools"
xcode-select --install

# Neovim
echo "Installing Neovim"
source ./neovim.sh

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

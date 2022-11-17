#!/bin/sh

# Xcode Developer Tools
xcode-select --install

# TMUX Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Homebrew packages, Cask binaries and Mac App Store software
source ./brew.sh

# Direnv
source ./direnv.sh

# Node.js
source ./nodejs.sh

# Python
source ./python.sh

# Lua
source ./lua.sh

# Rust
source ./rust.sh

# Ruby
source ./ruby.sh

# Golang
source ./golang.sh

# GitHub CLI Extensions
source ./github.sh

# Visual Studio Code Extensions
source ./vscode.sh

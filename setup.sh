#!/bin/bash

echo "Installing dotfiles"

# Function to run a command with sudo
run_with_sudo() {
	echo "$SUDO_PASSWORD" | sudo -S "$@"
}

# Function to prevent sleep
prevent_sleep() {
	caffeinate -d -i -m -s &
	CAFFEINATE_PID=$!
}

# Function to allow sleep again
allow_sleep() {
	kill $CAFFEINATE_PID
}

# Ask for the administrator password upfront and store it
read -s -p "Enter your sudo password: " SUDO_PASSWORD
echo

# Verify the sudo password
if ! echo "$SUDO_PASSWORD" | sudo -S true; then
	echo "Incorrect sudo password. Exiting."
	exit 1
fi

echo "Sudo access granted."

# Prevent sleep
prevent_sleep
echo "Sleep prevention activated."

# Trap to ensure we allow sleep when the script exits
trap allow_sleep EXIT

# Initializing Git submodules
echo "Initializing submodule(s)"
git submodule update --init --recursive

# Symlink dotfiles
./install

# Download wezterm.terminfo
curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Homebrew to PATH for the current session
	eval "$(/opt/homebrew/bin/brew shellenv)"

	echo "Homebrew installed successfully."
else
	echo "Homebrew is already installed."
fi

# Install Homebrew packages
echo "Restoring Homebrew packages..."
./bin/homebrew-restore

# Setup fish shell as default shell
echo "Configuring fish as default shell"
if ! command -v fish &>/dev/null; then
	echo "Fish shell not found. Installing fish..."
	brew install fish
fi

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh >/dev/null 2>&1

# GitHub CLI extensions
gh extension install github/gh-copilot
gh extension install dlvhdr/gh-dash
gh extension install jrnxf/gh-eco
gh extension install gennaro-tedesco/gh-f
gh extension install yusukebe/gh-markdown-preview
gh extension install meiji163/gh-notify
gh extension install seachicken/gh-poi
gh extension install gennaro-tedesco/gh-s

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# Install Fish plugins
fisher install jorgebucaran/fisher
fisher install jorgebucaran/autopair.fish
fisher install jorgebucaran/replay.fish
fisher install edc/bass
fisher install jethrokuan/z
fisher install joshmedeski/fish-lf-icons
fisher install jethrokuan/fzf

# Install Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Start services
yabai --start-service
skhd --start-service

# Change default shell to fish
echo "Changing default shell to fish"
run_with_sudo chsh -s $(which fish) $USER

echo "Done."
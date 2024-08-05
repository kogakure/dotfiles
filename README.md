# Dotfiles

## Install Dependencies

First, install the Xcode command-line tools:

```sh
xcode-select --install
```

## Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Initial Software

```sh
brew install stow
brew install --cask proton-pass
brew install --cask secretive
```

## Setup SSH

Log into the password manager, start and configure [Secretive](https://github.com/maxgoedjen/secretive) to setup SSH keys. Add the public key to GitHub and export the `SSH_AUTH_SOCK` (temporary) to be able to clone with SSH:

```sh
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
```

## Setup Hostname

```sh
sudo scutil --set HostName <hostname>
```

## Clone Dotfiles

```sh
git clone git@github.com:kogakure/dotfiles.git ~/.dotfiles
```

## Install Script

Log in with your Apple ID to be able to install app store apps. Run the install script to setup the computer:

```sh
cd ~/.dotfiles
./install.sh
```

# Nix Dotfiles

This is my dotfile setup, using [Nix](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

## Install Dependencies

First, install the Xcode command-line tools:

```sh
xcode-select --install
```

## Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Nix

Install Nix using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer):

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Prepare Configuration for Installation

```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

## Install the Nix Flake

> [!IMPORTANT]
> Make sure your Terminal has full disk access in the Security & Privacy settings.

### First-time Installation

#### Install from GitHub

To install and use this configuration directly from GitHub without cloning:

```sh
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake github:kogakure/dotfiles
```

#### Clone and Install

Clone the repository:

```sh
git clone git@github.com:kogakure/dotfiles.git ~/.dotfiles
```

For the initial setup, run:

```sh
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake ~/.dotfiles
```

This command installs nix-darwin and applies your configuration.

### Selecting a Specific Configuration

By default the `$hostname` that matches the current machine is used, but it is possible to manually load one by running:

```sh
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake ~/.dotfiles#mac-mini
```

## Updating Configuration

After making changes to your configuration, apply them with:

```sh
darwin-rebuild switch --flake ~/.dotfiles
```

## Inspiration

My setup is inspired by [davish’s Nix Setup](https://github.com/davish/setup) and by a lot of talking to [Claude 3.5](https://claude.ai/). 😅

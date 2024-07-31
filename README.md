# Nix Dotfiles

This is my dotfile setup, using [Nix](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

> [!WARNING]
> This is a work in progress and I am still learning Nix, so expect things to be broken.

## Install Dependencies

First, install the Xcode command-line tools:

```sh
xcode-select --install
```

## Install Nix

Install Nix using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer):

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Install the Nix Flake

### First-time Installation

#### Install from GitHub

To install and use this configuration directly from GitHub without cloning:

```sh
nix run nix-darwin -- switch --flake github:kogakure/dotfiles
```

#### Clone and Install

Clone the repository:

```sh
git clone git@github.com:kogakure/dotfiles.git ~/.dotfiles
```

For the initial setup, run:

```sh
nix run nix-darwin -- switch --flake ~/.dotfiles
```

This command installs nix-darwin and applies your configuration.

### Selecting a Specific Configuration

By default the `$hostname` that matches the current machine is used, but it is possible to manually load one by running:

```sh
nix run nix-darwin -- switch --flake ~/.dotfiles#mac-mini
```

## Updating Configuration

After making changes to your configuration, apply them with:

```sh
darwin-rebuild switch --flake ~/.dotfiles
```

# Nix Dotfiles

This is my folder where I migrate my current dotfile setup to [Nix](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

> [!WARNING]
> This is a work in progress and I am still learning Nix, so expect things to be broken.

## Install Dependencies

```sh
xcode-select --install
```

## Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Add this line to your `/etc/nix/nix.conf` file

```sh
experimental-features = nix-command flakes
```

```sh
# First time install
nix run nix-darwin -- switch --flake ~/.dotfiles/nix
```

By default the `$hostname` that matches the current machine is used, but it is possible to manually load one by running:

```sh
nix run nix-darwin -- switch --flake ~/.dotfiles/nix#mac-mini
```

Make sure this is added to your path:

```sh
export PATH="/run/current-system/sw/bin:$PATH"
```

```sh
# Switch to new configuration
darwin-rebuild switch --flake ~/.dotfiles/nix
```

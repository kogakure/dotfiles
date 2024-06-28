# Nix Dotfiles

This is my folder where I migrate my current dotfile setup to [Nix](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

> [!WARNING]
> This is a work in progress and I am still learning Nix, so expect things to be broken.

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

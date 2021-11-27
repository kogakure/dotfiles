# Dotfiles

## Homebrew

Fix the permissions of the target folder.

```sh
sudo chown -R $(whoami) /usr/local/var/
```

Install [Homebrew](https://brew.sh/) package managager.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Starship

Install a [Nerd Font](https://www.nerdfonts.com/).

Install [Starship](https://starship.rs/)

```sh
brew install starship
```

![Maintenance](https://img.shields.io/maintenance/yes/2022.svg)

# Dotfiles

These are my Dotfiles, a collection of [Neovim](https://neovim.io/), [tmux](https://tmux.github.io/), [zsh](http://zsh.sourceforge.net/), [Hammerspoon](http://www.hammerspoon.org/), and other tools.

## Initial Setup and Installation

```sh
git clone git@github.com:kogakure/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/
./install
```

Dotbot will create symlinks from all necessary files in the folder.

## Setting Up a New Computer

The project includes a `setup` folder that has install scripts for everything I need on a new computer. You can run the scripts individually or all at once by running `./setup/init.sh`.

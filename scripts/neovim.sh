#!/bin/sh

asdf plugin add neovim
nvim --headless "+Lazy! sync" +qa

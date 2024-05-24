#!/bin/sh

asdf plugin add rust
asdf install rust latest
asdf global rust latest

cargo install stylua

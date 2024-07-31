#!/bin/sh

asdf plugin add lua
asdf install lua 5.1
asdf install lua latest
asdf global lua latest

luarocks install --server=https://luarocks.org/dev luaformatter
sudo luarocks install --lua-version 5.1 tiktoken_core

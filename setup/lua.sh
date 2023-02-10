#!/bin/sh

asdf plugin add lua
asdf install lua latest
asdf global lua latest

luarocks install --server=https://luarocks.org/dev luaformatter

#!/bin/sh

asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest

bundle install --gemfile=~/.dotfiles/Gemfile

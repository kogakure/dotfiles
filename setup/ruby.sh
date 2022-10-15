#!/bin/sh

rbenv install $(rbenv install -l | grep -v - | tail -1)
rbenv global $(rbenv install -l | grep -v - | tail -1)

bundle install --gemfile=~/.dotfiles/Gemfile

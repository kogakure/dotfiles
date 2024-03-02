#!/bin/sh

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install edc/bass
fisher install jethrokuan/fzf
fisher install jethrokuan/z
fisher install jorgebucaran/autopair.fish
fisher install jorgebucaran/replay.fish
fisher install joshmedeski/fish-lf-icons

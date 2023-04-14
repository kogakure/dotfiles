#!/bin/sh

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install jethrokuan/z
fisher install edc/bass
fisher install jorgebucaran/replay.fish
fisher install jorgebucaran/autopair.fish
fisher install gazorby/fish-abbreviation-tips


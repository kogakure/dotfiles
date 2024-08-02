{ pkgs, ... }:

{
  home.file = {
    ".asdfrc" = { source = ./asdfrc; };
    ".default-gems" = { source = ./default-gems; };
    ".default-npm-packages" = { source = ./default-npm-packages; };
    ".default-python-packages" = { source = ./default-python-packages; };
  };
}

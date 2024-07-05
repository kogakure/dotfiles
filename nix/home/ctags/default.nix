{ pkgs, ... }:

{
  home.file.".ctags" = {
    source = ./ctags;
  };

  home.packages = [
    pkgs.universal-ctags
  ];
}

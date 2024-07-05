{ pkgs, ... }:

{
  home.file.".ag" = {
    source = ./ag;
  };

  home.packages = [
    pkgs.silver-searcher
  ];
}

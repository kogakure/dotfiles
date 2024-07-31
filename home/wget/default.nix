{ pkgs, ... }:

{
  home.file = {
    ".wget" = { source = ./wget; };
  };

  home.packages = [ pkgs.wget ];
}

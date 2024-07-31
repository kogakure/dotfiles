{ pkgs, ... }:

{
  home.file.".config/karabiner/" = {
    source = ./karabiner;
  };

  home.packages = [ pkgs.karabiner-elements ];
}

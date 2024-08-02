{ pkgs, ... }:

{
  home.file.".config/karabiner/" = {
    source = ./karabiner;
  };
}

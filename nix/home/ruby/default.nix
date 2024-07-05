{ pkgs, ... }:

{
  home.file.".gemrc" = {
    source = ./gemrc;
  };

  home.packages = [
    pkgs.ruby
  ];
}

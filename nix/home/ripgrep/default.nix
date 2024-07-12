{ pkgs, ... }:

{
  home.file.".config/ripgrep/ripgreprc" = {
    source = ./ripgreprc;
  };

  programs.ripgrep = {
    enable = true;
  };

  home.packages = [ pkgs.ripgrep ];
}

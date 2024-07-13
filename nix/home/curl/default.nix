{ pkgs, ... }:

{
  home.file = {
    ".curlrc" = { source = ./curlrc; };
  };

  home.packages = [ pkgs.curl ];
}

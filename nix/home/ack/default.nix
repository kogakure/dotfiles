{ pkgs, ... }:

{
  home.file.".ack" = {
    source = ./ack;
  };

  home.packages = [ pkgs.ack ];
}

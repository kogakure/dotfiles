{ pkgs, config, ... }:

{
  imports = [
    ../../darwin
  ];

  users.users.kogakure = {
    name = "kogakure";
    home = "/Users/kogakure";
  };

  homebrew = import ./homebrew.nix;
}
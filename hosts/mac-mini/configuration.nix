{ config, ... }:

{
  imports = [
    ../../darwin
  ];

  users.users.kogakure = {
    name = "kogakure";
    home = "/Users/kogakure";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Screenshots
  system.defaults.screencapture.location = "${config.users.users.kogakure.home}/Dropbox/Bilder/Screenshots";

  homebrew = import ./homebrew.nix;
}

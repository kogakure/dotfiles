{ config, ... }:

{
  imports = [
    ../../darwin
  ];

  users.users.kogakure = {
    name = "stefan.imhoff";
    home = "/Users/stefan.imhoff";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Screenshots
  system.defaults.screencapture.location = "${config.users.users."stefan.imhoff".home}/Dropbox/Bilder/Screenshots";

  homebrew = import ./homebrew.nix;
}

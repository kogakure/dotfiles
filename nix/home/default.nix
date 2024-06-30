{ pkgs, config, lib, home-manager, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # https://nix-community.github.io/home-manager/options.html
  imports = [
    ./ack
    ./ripgrep
    ./skhd
    ./yabai
  ];

  config = {
    home.stateVersion = "23.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # TODO: First migrate all fonts
    # fonts.fontconfig.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      nixpkgs-fmt # Nix code formatter
    ];
  };
}

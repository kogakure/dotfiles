{ pkgs, config, lib, home-manager, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # https://nix-community.github.io/home-manager/options.html
  imports = [
    ./ack
    ./ag
    ./asdf
    ./bat
    ./ctags
    ./curl
    ./editorconfig
    ./gnupg
    ./hammerspoon
    ./karabiner
    ./lazydocker
    ./lazygit
    ./lf
    ./oatmeal
    ./ripgrep
    ./ruby
    ./sesh
    ./skhd
    ./wget
    ./yabai
    ./yazi
    ./zed
  ];

  config = {
    home.stateVersion = "23.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Write into ~/.config
    xdg.enable = true;

    # TODO: First migrate all fonts
    # fonts.fontconfig.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      comma # Comma runs software without installing it
      nixd # Nix language server
      nixpkgs-fmt # Nix code formatter
    ];
  };
}

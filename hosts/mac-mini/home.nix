{ pkgs, ... }:

{
  imports = [
    ../../home
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    discord # All-in-one cross-platform voice and text chat for gamers
  ];
}

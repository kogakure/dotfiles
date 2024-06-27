{ pkgs, ... }:

{
  imports = [
    ../../home
  ];

  services.yabai.enable = true;
  services.skhd.enable = true;
}

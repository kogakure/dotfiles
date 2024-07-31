{ pkgs, config, lib, ... }:

{
  options.services.skhd = {
    enable = lib.mkEnableOption "skhd";
  };

  config = {
    home.file.".config/skhd/skhdrc" = lib.mkIf
      config.services.skhd.enable
      {
        source = ./skhdrc;
        onChange = "${pkgs.killall}/bin/killall skhd";
      };
  };
}

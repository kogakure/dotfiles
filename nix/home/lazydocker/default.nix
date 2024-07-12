{ pkgs, ... }:

{
  home.file.".config/lazydocker/config.yml" = {
    source = ./lazydocker.yml;
  };

  home.packages = [ pkgs.lazydocker ];
}

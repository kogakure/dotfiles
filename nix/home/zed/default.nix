{ pkgs, ... }:

{
  home.file = {
    ".config/zed/settings.json" = { source = ./settings.json; };
  };

  # TODO: Currently broken, installed with Homebrew
  # home.packages = [ pkgs.zed-editor ];
}

{ pkgs, ... }:

{
  home.file = {
    ".config/zed/settings.json" = { source = ./settings.json; };
  };

  # FIX: Currently broken, installed with Homebrew
  # home.packages = [ pkgs.zed-editor ];
}

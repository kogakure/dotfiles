{ config, lib, pkgs, ... }:

{
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/neovim/nvim";
    recursive = true;
  };

  home.packages = [ pkgs.neovim ];
}

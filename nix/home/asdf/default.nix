{ pkgs, ... }:

{
  home.file = {
    ".asdfrc" = { source = ./asdfrc; };
    ".tool-versions" = { source = ./tool-versions; };
    ".default-gems" = { source = ./default-gems; };
    ".default-npm-packages" = { source = ./default-npm-packages; };
    ".default-python-packages" = { source = ./default-python-packages; };
    ".asdf/lib".source = "${pkgs.asdf-vm}/share/asdf-vm/lib";
  };

  home.packages = [
    pkgs.asdf-vm
  ];
}

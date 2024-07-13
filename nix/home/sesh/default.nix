{ pkgs, ... }:

{
  home.file = {
    ".config/sesh/sesh.toml" = { source = ./sesh.toml; };
    ".config/sesh/scripts/node_dev" = { source = ./scripts/node_dev; };
    ".config/sesh/scripts/open_files" = { source = ./scripts/open_files; };
  };

  home.packages = [ pkgs.sesh ];
}

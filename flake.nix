{
  description = "My Darwin and home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, mac-app-util }:
    let
      mkDarwinConfig = { system, hostname, username }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit pkgs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
              home-manager.users.${username} = {
                imports = [
                  ./hosts/${hostname}/home.nix
                  mac-app-util.homeManagerModules.default
                ];
              };
              home-manager.extraSpecialArgs = { inherit pkgs; };
            }
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake ~/.dotfiles/.#mac-mini
      darwinConfigurations = {
        "mac-mini" = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "mac-mini";
          username = "kogakure";
        };
        "macbook-2023" = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "macbook-2023";
          username = "stefan.imhoff";
        };
      };
    };
}


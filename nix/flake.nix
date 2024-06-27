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

  outputs = { self, nix-darwin, home-manager, nixpkgs, mac-app-util }: {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake ~/.dotfiles/nix/.#mac-mini
    darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/mac-mini/configuration.nix

        mac-app-util.darwinModules.default

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.kogakure.imports = [ ./hosts/mac-mini/home.nix mac-app-util.homeManagerModules.default ];
        }
      ];
    };
  };
}

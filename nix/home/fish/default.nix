{ lib, pkgs, ... }:

let
  sharedAliases = import ../shared/shared-aliases.nix { inherit lib; };

  # Function to read a file and return its contents as a string
  readFile = file: builtins.readFile (./. + "/functions/${file}");

  # List of function files
  functionFiles = [
    "dataUrl.fish"
    "deleteNodeModules.fish"
    "encodeBase64.fish"
    "fcd.fish"
    "fe.fish"
    "fhcd.fish"
    "fs.fish"
    "fwt.fish"
    "ghpr.fish"
    "server.fish"
    "unquarantine.fish"
    "update.fish"
  ];

  # Create a set of functions, where each key is the function name (without .fish extension)
  # and the value is the contents of the file
  fishFunctions = builtins.listToAttrs (map
    (file: {
      name = lib.removeSuffix ".fish" file;
      value = readFile file;
    })
    functionFiles
  );
in
{
  programs.fish = {
    enable = true;

    # Shell options
    interactiveShellInit = ''
      # Enable vi-mode key bindings
      fish_vi_key_bindings

      # Set environment variables
      set -gx TERM wezterm
    '';

    shellAliases = sharedAliases.shellAliases;

    functions = fishFunctions;

    plugins = [
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "replay.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "d2ecacd3fe7126e822ce8918389f3ad93b14c86c";
          sha256 = "TzQ97h9tBRUg+A7DSKeTBWLQuThicbu19DHMwkmUXdg=";
        };
      }
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
          sha256 = "3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "fish-lf-icons";
        src = pkgs.fetchFromGitHub {
          owner = "joshmedeski";
          repo = "fish-lf-icons";
          rev = "d1c47b2088e0ffd95766b61d2455514274865b4f";
          sha256 = "6po/PYvq4t0K8Jq5/t5hXPLn80iyl3Ymx2Whme/20kc=";
        };
      }
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
  };
}

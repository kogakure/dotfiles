{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      map-syntax = [
        ".*ignore:Git Ignore"
        ".gitconfig.local:Git Config"
        "flake.lock:JSON"
      ];
      pager = "less -FR";
      style = "numbers,changes,header,grid";
      theme = "catppuccin-mocha";
      wrap = "never";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff # Diff a file against the current git index, or display the diff between two files.
      batgrep # Quickly search through and highlight files using ripgrep.
      batman # Read system manual pages (man) using bat as the manual page formatter.
      batpipe # A less (and soon bat) preprocessor for viewing more types of files in the terminal.
      batwatch # Watch for changes in files or command output, and print them with bat.
      prettybat # Pretty-print source code and highlight it with bat.
    ];
    themes = {
      catppuccin-mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
      catppuccin-frappe = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Frappe.tmTheme";
      };
      catppuccin-latte = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Latte.tmTheme";
      };
      catppuccin-macchiato = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };

  home.packages = [ pkgs.bat ];
}

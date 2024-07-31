{ pkgs, ... }:

let
  # TODO: Wait for plugin in https://github.com/NixOS/nixpkgs/blob/maser/pkgs/misc/tmux-plugins/default.nix or add it with a PR
  tmux-nerd-font-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nerd-font-window-name";
    version = "v2.1.1";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "tmux-nerd-font-window-name";
      rev = "57961cb0a99b76f20e02639d398c973d81971d05";
      sha256 = "8P4jFEkcJn/JbdRAC5PCrLAGTJwFxCknllOjkD+PK9w=";
    };
    # INFO: Needed rename, because nix uses underscores
    postInstall = ''
      mv $target/tmux-nerd-font-window-name.tmux $target/tmux_nerd_font_window_name.tmux
    '';
  };
in
{
  home.file = {
    ".config/tmux/tmux-nerd-font-window-name.yml" = {
      source = ./tmux-nerd-font-window-name.yml;
    };
    ".gitmux.conf" = { source = ./gitmux.conf; };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    sensibleOnTop = false;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      battery
      copycat
      logging
      open
      pain-control
      sessionist
      urlview
      yank
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10' # Save every 10 minutes
        '';
      }
      {
        plugin = jump;
        extraConfig = "set -g @jump-key 's'";
      }
      better-mouse-mode
      vim-tmux-navigator
      {
        plugin = tmux-nerd-font-window-name;
        extraConfig = "set -g @tmux-nerd-font-window-name-show-name true";
      }
    ];
  };

  home.packages = with pkgs; [
    gitmux
    # Dependencies of joshmedeski/tmux-nerd-font-window-name
    yq-go
    nodePackages.bash-language-server
  ];
}

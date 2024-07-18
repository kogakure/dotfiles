{ pkgs, config, lib, home-manager, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # https://nix-community.github.io/home-manager/options.html
  imports = [
    ./ack
    ./ag
    ./asdf
    ./bat
    ./ctags
    ./curl
    ./editorconfig
    ./gh
    ./gh-dash
    ./git
    ./gnupg
    ./hammerspoon
    ./karabiner
    ./lazydocker
    ./lazygit
    ./lf
    ./oatmeal
    ./ripgrep
    ./ruby
    ./sesh
    ./skhd
    ./wezterm
    ./wget
    ./yabai
    ./yazi
    ./zed
  ];

  config = {
    home.stateVersion = "23.05";

    home.activation = {
      # Install terminfo for wezterm
      installWeztermProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tempfile=$(mktemp) \
        && ${pkgs.curl}/bin/curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
        && tic -x -o ~/.terminfo $tempfile \
        && rm $tempfile
      '';
      # Install custom icon for WezTerm
      setupWezTermCustomIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        icon_path="$HOME/.config/wezterm/terminal.icns"
        app_path="/Applications/WezTerm.app"

        $DRY_RUN_CMD mkdir -p "$(dirname "$icon_path")"
        $DRY_RUN_CMD cp -f ${./wezterm/wezterm.icns} "$icon_path"

        if [ -d "$app_path" ]; then
          $DRY_RUN_CMD cp "$icon_path" "$app_path"/Contents/Resources/terminal.icns

          # Touch the app to refresh Finder
          $DRY_RUN_CMD touch "$app_path"
          $DRY_RUN_CMD ${pkgs.darwin.xattr}/bin/xattr -rc "$app_path"

          $VERBOSE_ECHO "Applied custom icon to WezTerm.app"
          $DRY_RUN_CMD touch "$app_path"
        else
          $VERBOSE_ECHO "WezTerm.app not found in /Applications. Custom icon not applied."
        fi
      '';
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Write into ~/.config
    xdg.enable = true;

    # TODO: First migrate all fonts
    # fonts.fontconfig.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      comma # Comma runs software without installing it
      nixd # Nix language server
      nixpkgs-fmt # Nix code formatter
      darwin.xattr # Display and manipulate extended attributes
    ];
  };
}

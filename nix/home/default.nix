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
      atuin # Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
      bash # GNU Bourne-Again Shell, the de facto standard shell on Linux
      bfg-repo-cleaner # Removes large or troublesome blobs in a git repository like git-filter-branch does, but faster
      btop # Monitor of resources
      bzip2 # High-quality data compression program
      cloc # Program that counts lines of source code
      comma # Comma runs software without installing it
      coreutils # GNU Core Utilities
      darwin.xattr # Display and manipulate extended attributes
      diff-so-fancy # Good-looking diffs filter for git
      docker-buildx # Docker CLI plugin for extended build capabilities with BuildKit
      dust # du + rust = dust. Like du but more intuitive
      exiftool # Tool to read, write and edit EXIF meta information
      eza # Modern, maintained replacement for ls
      fd # Simple, fast and user-friendly alternative to find
      ffmpeg_7 # Complete, cross-platform solution to record, convert and stream audio and video
      fzf # Command-line fuzzy finder written in Go
      glow # Render markdown on the CLI, with pizzazz!
      gource # Software version control visualization tool
      grex # Command-line tool for generating regular expressions from user-provided test cases
      highlight # Source code highlighting tool
      htop # Interactive process viewer
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      hyperfine # Command-line benchmarking tool
      jless # Command-line pager for JSON data
      jq # Lightweight and flexible command-line JSON processor
      lynx # Text-mode web browser
      monolith # Bundle any web page into a single HTML file
      nixd # Nix language server
      nixpacks # App source + Nix packages + Docker = Image Resources
      nixpkgs-fmt # Nix code formatter
      openai-whisper-cpp # Port of OpenAI's Whisper model in C/C++
      openssl # A cryptographic library that implements the SSL and TLS protocols
      pngpaste # Paste image files from clipboard to file on MacOS
      pnpm # Fast, disk space efficient package manager for JavaScript
      prettierd # Prettier, as a daemon, for improved formatting speed
      reattach-to-user-namespace # Wrapper that provides access to the Mac OS X pasteboard service
      remarshal # Convert between TOML, YAML and JSON
      rsync # Fast incremental file transfer utility
      sad # CLI tool to search and replace
      silicon # Create beautiful image of your source code
      ssh-copy-id # Tool to copy SSH public keys to a remote machine
      tldr # Simplified and community-driven man pages
      tree # Command to produce a depth indented directory listing
      unar # Archive unpacker program
      vhs # Tool for generating terminal GIFs with code
      watchman # Watches files and takes action when they change
      woff2 # Webfont compression reference code
      yarn # Fast, reliable, and secure dependency management for javascript
      yt-dlp # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
      zoxide # Fast cd command that learns your habits

      # Programming Languages
      lua # Powerful, fast, lightweight, embeddable scripting language
      nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine
      perl # Standard implementation of the Perl 5 programming language
      php # HTML-embedded scripting language
      python3 # High-level dynamically-typed programming language
      ruby # Object-oriented language for quick and easy programming
      rustc # Safe, concurrent, practical language (wrapper script)

      # Server & Databases
      mysql84 # World's most popular open source database
      nginx # Reverse proxy and lightweight webserver
      postgresql # Powerful, open source object-relational database system
      sqlite # A self-contained, serverless, zero-configuration, transactional SQL database engine

      # Applications
      alt-tab-macos # Windows alt-tab on macOS
      appcleaner # Uninstall unwanted apps
      audacity # Sound editor with graphical UI
      bartender # Take control of your menu bar
      iina # Modern media player for macOS
      keycastr # Open-source keystroke visualizer
      openfortivpn # Client for PPP+SSL VPN tunnel services
      sequelpro # MySQL database management for macOS
      telegram-desktop # Telegram Desktop messaging app
    ];
  };
}

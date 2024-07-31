{ pkgs, config, ... }:

{
  homebrew = import ./homebrew-common.nix;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.karabiner-elements.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  environment.systemPackages = [ pkgs.pinentry_mac ];

  # Shells
  environment.shells = with pkgs; [
    bash
    zsh
    fish
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.bash.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # General UI/UX
  system.defaults.NSGlobalDomain = {
    # Set Dark Mode
    AppleInterfaceStyle = "Dark";

    # Set language and text formats
    AppleMeasurementUnits = "Centimeters";

    ApplePressAndHoldEnabled = false;

    # Finder: show all filename extensions
    AppleShowAllExtensions = true;

    # Set a blazingly fast keyboard repeat rate
    KeyRepeat = 2;
    InitialKeyRepeat = 15;

    # Disable automatic capitalization as it’s annoying when typing code
    NSAutomaticCapitalizationEnabled = false;

    # Disable smart dashes as they’re annoying when typing code
    NSAutomaticDashSubstitutionEnabled = false;

    # Disable automatic period substitution as it’s annoying when typing code
    NSAutomaticPeriodSubstitutionEnabled = false;

    # Disable smart quotes as they’re annoying when typing code
    NSAutomaticQuoteSubstitutionEnabled = false;

    # Disable auto-correct
    NSAutomaticSpellingCorrectionEnabled = false;

    # Expand save panel by default
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;

    # Set sidebar icon size
    NSTableViewDefaultSizeMode = 3;

    # Expand print panel by default
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;
  };

  # Disable the “Are you sure you want to open this application?” dialog
  system.defaults.LaunchServices.LSQuarantine = false;

  # Reduce Motion
  system.defaults.universalaccess.reduceMotion = true;

  # Finder
  system.defaults.finder = {
    # Finder: show all filename extensions
    AppleShowAllExtensions = true;

    # When performing a search, search the current folder by default
    FXDefaultSearchScope = "SCcf";

    # Disable the warning when changing a file extension
    FXEnableExtensionChangeWarning = false;

    # Show path breadcrumbs in finder windows.
    ShowPathbar = true;

    # Show status bar at bottom of finder windows with item/disk space stats.
    ShowStatusBar = true;

    # Change the default finder view. “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View
    FXPreferredViewStyle = "clmv";
  };

  # Magic Mouse
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  # Dock
  system.defaults.dock = {
    # Automatically hide and show the Dock
    autohide = true;

    # Remove the auto-hiding Dock delay
    autohide-delay = 0.0;

    # Remove the animation when hiding/showing the Dock
    autohide-time-modifier = 0.0;

    # Speed up Mission Control animations
    expose-animation-duration = 0.1;

    # Don’t animate opening applications from the Dock
    launchanim = false;

    # Change minimize/maximize window effect
    mineffect = "scale";

    # Minimize windows into their application’s icon
    minimize-to-application = true;

    # Don’t automatically rearrange Spaces based on most recent use
    mru-spaces = false;

    # Hide indicator lights for open applications in the Dock
    show-process-indicators = true;

    # Don’t show recent applications in Dock
    show-recents = false;

    # Make Dock icons of hidden applications translucent
    showhidden = true;

    # Set the icon size of Dock items to 36 pixels
    tilesize = 36;

    # Hot corners
    wvous-br-corner = 10; # bottom right (Put display to sleep)
    wvous-tl-corner = 4; # top left (Desktop)
    wvous-tr-corner = 12; # top right (Mission Control)

    # Apps in the Dock
    persistent-apps = [
      "/Applications/Things3.app"
      "/Applications/Proton\ Mail.app"
      "/System/Applications/Calendar.app"
      "/Applications/WezTerm.app"
      "/Applications/Arc.app"
      "/Applications/Brave\ Browser.app"
      "/System/Applications/Messages.app"
      "/Applications/iA\ Writer.app"
      "/Applications/Obsidian.app"
      "/Applications/DEVONthink\ 3.app"
      "/Applications/Eagle.app"
      "/Applications/Spotify.app"
      "/Applications/Anki.app"
      "/Applications/Proton\ Pass.app"
      "/System/Applications/System\ Settings.app"
    ];
  };

  # Trackpad, mouse, keyboard, Bluetooth accessories, and input
  system.defaults.trackpad = {
    # Whether to enable trackpad tap to click.
    Clicking = true;

    # Whether to enable trackpad right click.
    TrackpadRightClick = true;

    # Whether to enable tap-to-drag.
    Dragging = true;
  };

  # Finder
  system.activationScripts.postActivation.text = ''
    # Show the ~/Library folder
    chflags nohidden ~/Library

    # Show the /Volumes folder
    sudo chflags nohidden /Volumes
  '';

  # Additional system configurations
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.AppleFontSmoothing = 2;

  # Services
  services.skhd.enable = true;
  services.yabai.enable = true;
}

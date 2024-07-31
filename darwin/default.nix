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

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.dock.autohide = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.skhd.enable = true;
  services.yabai.enable = true;
}

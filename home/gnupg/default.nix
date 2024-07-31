# TODO: Move public/private keys into nix
{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    settings = {
      auto-key-retrieve = true;
      no-emit-version = true;
      use-agent = true;
      default-key = "F0CF1CF481C2E3AA0F806A378BD4525D7A7253E8";
    };

    # GPG agent configuration
    # These settings go into gpg-agent.conf
    # NOTE: pinentry-program is set differently for macOS (see below)
    scdaemonSettings = { };
  };

  # For macOS, we need to set the pinentry-program separately
  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    default-cache-ttl 600
    max-cache-ttl 7200
  '';

  home.packages = with pkgs; [
    pinentry_mac
  ];
}

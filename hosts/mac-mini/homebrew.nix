{
  onActivation.cleanup = "uninstall";
  taps = [ ];
  brews = [ ];
  casks = [
    "ankerwork" # Webcam & audio device software
    "daisydisk" # Disk space visualiser
    "forticlient-vpn" # Free VPN client for FortiClient
    "gemini" # Disk space cleaner that finds and deletes duplicated and similar files
    "handbrake" # Open-source video transcoder. FIX: Broken on nixpks
    "lbry" # Official client for LBRY, a decentralised file-sharing and payment network
    "makemkv" # Video format converter (transcoder)
    "protonvpn" # VPN client focusing on security
    "raspberry-pi-imager" # # Imaging utility to install operating systems to a microSD card
    "sweet-home3d" # Interior design application
    "tor-browser" # Web browser focusing on security
    "webtorrent" # Torrent streaming application
  ];
  masApps = { };
}

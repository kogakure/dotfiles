{
  enable = true;
  # TODO: Activate after migration is complete
  # onActivation.cleanup = "uninstall";
  taps = [
    "dustinblackman/tap" # Oatmeal
    "homebrew/bundle" # Bundler for non-Ruby dependencies from Homebrew, Homebrew Cask, Mac App Store, Whalebrew and Visual Studio Code.
    "homebrew/services" # Manage background services using the daemon manager launchctl on macOS or systemctl on Linux.
  ];
  brews = [
    "cava" # Console-based Audio Visualizer for ALSA
    "fileicon" # macOS CLI for managing custom icons for files and folders
    "oatmeal" # Terminal UI to chat with large language models (LLM) using backends such as Ollama, and direct integrations with your favourite editor like Neovim!
    "prettier" # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
  ];
  casks = [
    "affinity-designer" # Professional graphic design software
    "affinity-photo" # Professional image editing software
    "affinity-publisher" # Professional desktop publishing software
    "alfred" # Application launcher and productivity software
    "angry-ip-scanner" # Network scanner
    "anki" # Memory training application. FIX: Broken on nixpks
    "arc" # Chromium based browser
    "bibdesk" # Edit and manage bibliographies
    "blender" # 3D creation suite. FIX: Installation fails with broken Xcode derivation
    "blender-benchmark" # 3D performance benchmarking tool
    "blurred" # Utility to dim background/inactive content in the screen
    "brave-browser" # Web browser focusing on privacy
    "calibre" # E-books management software. FIX: Broken on nixpks
    "cleanshot" # Screen capturing tool
    "color-oracle" # Tool to test for color-blindness
    "cryptomator" # Multi-platform client-side cloud file encryption tool
    "db-browser-for-sqlite" # Browser for SQLite databases
    "deepl" # Trains AIs to understand and translate texts
    "devonthink" # Collect, organise, edit and annotate documents
    "docker" # App to build and share containerised applications and microservices
    "dropbox" # Client for the Dropbox cloud storage service
    "figma" # Collaborative team software
    "firefox" # Web browser
    "firefox@developer-edition" # Web browser
    "forticlient-vpn" # Free VPN client for FortiClient
    "google-japanese-ime" # Japanese input software
    "gpg-suite-no-mail" # Tools to protect your files
    "hammerspoon" # Desktop automation application
    "ia-presenter" # Create presentation slides from a Markdown document
    "imageoptim" # Tool to optimise images to a smaller size
    "integrity" # Tool to scan a website checking for broken links
    "itsycal" # Menu bar calendar
    "kaleidoscope@3" # Spot and merge differences in text and image files or folders
    "kap" # Open-source screen recorder built with web technology
    "languagetool" # Grammar, spelling and style suggestions in all the writing apps
    "ledger-live" # Wallet desktop application to maintain multiple cryptocurrencies
    "macfuse" # File system integration
    "microsoft-outlook" # Email client
    "microsoft-teams" # Meet, chat, call, and collaborate in just one place
    "notion" # App to write, plan, collaborate, and get organised
    "obsidian" # Knowledge base that works on top of a local folder of plain text Markdown files
    "ogdesign-eagle" # Organise all your reference images in one place
    "ollama" # Get up and running with large language models locally
    "philips-hue-sync" # Control your smart light system
    "proton-drive" # Client for Proton Drive
    "proton-mail" # Client for Proton Mail and Proton Calendar
    "proton-pass" # Desktop client for Proton Pass
    "protonmail-bridge" # Bridges Proton Mail to email clients supporting IMAP and SMTP protocols
    "raindropio" # All-in-one bookmark manager
    "raycast" # Control your tools with a few keystrokes
    "reader" # Save articles to read, highlight key content, and organise notes for review
    "secretive" # Store SSH keys in the Secure Enclave
    "send-to-kindle" # Tool for sending personal documents to Kindles from Macs
    "session" # Onion routing based messenger
    "sf-symbols" # Tool that provides consistent, highly configurable symbols for apps
    "signal" # Instant messaging application focusing on security
    "sonos" # Control your Sonos system
    "spotify" # Music streaming service
    "the-unarchiver" # Unpacks archive files
    "transmit" # File transfer application
    "veracrypt" # Disk encryption software focusing on security based on TrueCrypt
    "visual-studio-code" # Open-source code editor
    "vlc" # Multimedia player
    "vlc-webplugin" # Web browser plugin
    "wezterm" # GPU-accelerated cross-platform terminal emulator and multiplexer. NOTE: Only installed with Brew because I want to replace the icon
    "whatsapp" # Native desktop client for WhatsApp
    "zed" # Multiplayer code editor
  ];
  masApps = { };
}

{
  enable = true;
  onActivation.cleanup = "uninstall";
  taps = [
    "dustinblackman/tap" # Oatmeal
    "homebrew/bundle" # Bundler for non-Ruby dependencies from Homebrew, Homebrew Cask, Mac App Store, Whalebrew and Visual Studio Code.
    "homebrew/services" # Manage background services using the daemon manager launchctl on macOS or systemctl on Linux.
    "koekeishiya/formulae" # yabai/skhd
  ];
  brews = [
    "asdf" # Extendable version manager with support for Ruby, Node.js, Erlang & more
    "cava" # Console-based Audio Visualizer for ALSA
    "cmake" # Cross-platform make
    "fileicon" # macOS CLI for managing custom icons for files and folders
    "gettext" # INFO: Dependency of Neovim
    "libiconv" # INFO: Dependency of nixpkgs_fmt
    "luajit" # INFO: Dependency of Neovim
    "neovim" # TODO: Migrate to nix
    "oatmeal" # Terminal UI to chat with large language models (LLM) using backends such as Ollama, and direct integrations with your favourite editor like Neovim!
    "pinentry-mac" # Pinentry for GPG
    "prettier" # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
    "skhd" # Simple hotkey daemon for macOS
    "tree-sitter" # INFO: Dependency of Neovim
    "urlview" # URL extractor/launcher
    "volta" # JavaScript toolchain manager for reproducible environments
    "yabai" # Tiling window manager for macOS based on binary space partitioning
    "yarn" # JavaScript package manager
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
    "font-fira-code"
    "font-fira-code-nerd-font"
    "font-fira-sans"
    "font-fira-sans-condensed"
    "font-hack-nerd-font"
    "font-ia-writer-duo"
    "font-ia-writer-mono"
    "font-ia-writer-quattro"
    "font-monaspace"
    "font-noto-emoji"
    "font-symbols-only-nerd-font"
    "google-japanese-ime" # Japanese input software
    "gpg-suite-no-mail" # Tools to protect your files
    "hammerspoon" # Desktop automation application
    "ia-presenter" # Create presentation slides from a Markdown document
    "imageoptim" # Tool to optimise images to a smaller size
    "integrity" # Tool to scan a website checking for broken links
    "itsycal" # Menu bar calendar
    "kaleidoscope@3" # Spot and merge differences in text and image files or folders
    "kap" # Open-source screen recorder built with web technology
    "karabiner-elements" # Keyboard customisation tool
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
    "pictogram" # Customise and maintain app icons
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
    "virtualbox@beta" # Virtualizer for x86 and arm64 hardware
    "visual-studio-code" # Open-source code editor
    "vlc" # Multimedia player
    "vlc-webplugin" # Web browser plugin
    "wezterm" # GPU-accelerated cross-platform terminal emulator and multiplexer. NOTE: Only installed with Brew because I want to replace the icon
    "whatsapp" # Native desktop client for WhatsApp
    "wiso-steuer-2024" # Tax declaration for the fiscal year 2023
    "zed" # Multiplayer code editor
  ];
  masApps = {
    "1-Click Video Converter" = 717545086; # Video converter
    "Aiko" = 1672085276; # Audio to text converter with AI
    "DaVinci Resolve" = 571213070; # Video Editing
    "Day One" = 1055511498; # Journaling
    "Deliveries" = 290986013; # Track parcels
    "Draw Things" = 6444050820; # Stable Diffusion AI art generation
    "Exporter" = 1099120373; # Export from Apple Notes
    "Free MP4 Converter" = 693443591; # Video converter
    "Goodnotes" = 1444383602; # Note-taking
    "Key Codes" = 414568915; # Keyboard key codes
    "Kindle" = 302584613; # E-book reader
    "Mela" = 1568924476; # Recipe manager
    "MindNode" = 1289197285; # Mind mapping
    "Numbers" = 409203825; # Spreadsheet
    "Pages" = 409201541; # Word processor
    "Proton Pass for Safari" = 6502835663; # Password manager browser extension
    "Pure Paste" = 1611378436; # Paste plain text by default
    "Reeder" = 1529448980; # RSS reader
    "Save to Raindrop.io" = 1549370672; # Bookmark manager browser extension
    "iA Writer" = 775737590; # Writing
    "iFinance 5" = 1500241909; # Banking
    "Time Sink" = 404363161; # Time tracking
    "Typeface" = 1062679359; # Font manager
    "Yoink" = 457622435; # Drag and drop
  };
}

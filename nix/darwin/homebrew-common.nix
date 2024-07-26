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
    "hammerspoon" # Desktop automation application
    "raycast" # Control your tools with a few keystrokes
    "wezterm" # GPU-accelerated cross-platform terminal emulator and multiplexer. NOTE: Only installed with Brew because I want to replace the icon
    "zed" # Multiplayer code editor
  ];
  masApps = { };
}

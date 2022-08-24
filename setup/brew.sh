#!/bin/sh

############
### Taps ###
############

brew tap homebrew/core
brew tap homebrew/bundle
brew tap homebrew/services
brew tap jondot/tap
brew tap cooklang/tap

# Install Java as dependency
brew cask install java

#############
### Brews ###
#############

brew install ack                        # Search tool like grep, but optimized for programmers
brew install bash                       # Bourne-Again SHell, a UNIX command interpreter
brew install bat                        # Clone of cat(1) with syntax highlighting and Git integration
brew install bfg                        # Remove large files or passwords from Git history like git-filter-branch
brew install bibclean                   # BibTeX bibliography file pretty printer and syntax checker
brew install bitwarden-cli              # Secure and free password manager for all of your devices
brew install cairo                      # Vector graphics library with cross-device output support
brew install cloc                       # Statistics utility to count lines of code
brew install closure-compiler           # JavaScript optimizing compiler
brew install cmake                      # Cross-platform make
brew install cooklang/tap/cook          # CLI tool for CookLang Recipe Markup Language
brew install coreutils                  # GNU File, Shell, and Text utilities
brew install curl                       # Get a file from an HTTP, HTTPS or FTP server
brew install denisidoro/tools/navi      # An interactive cheatsheet tool for the command-line ➜  navi
brew install deno                       # Secure runtime for JavaScript and TypeScript
brew install direnv                     # Load/unload environment variables based on $PWD
brew install docker                     # Pack, ship and run any application as a lightweight container
brew install docker-machine             # Create Docker hosts locally and on cloud providers
brew install editorconfig               # Maintain consistent coding style between multiple editors
brew install eot-utils                  # Tools to convert fonts from OTF/TTF to EOT format
brew install exa                        # Modern replacement for 'ls'
brew install fd                         # Simple, fast and user-friendly alternative to find
brew install ffmpeg --with-libvpx --with-libvorbis --with-fdk-aacc --with-libsass --with-fontconfig # Play, record, convert, and stream audio and video
brew install flow                       # Static type checker for JavaScript
brew install fontforge                  # Command-line outline and bitmap font editor/converter
brew install freetype                   # Software library to render fonts
brew install gcc                        # GNU compiler collection
brew install giflib                     # GIF library using patented LZW algorithm
brew install git                        # Distributed revision control system
brew install git-extras                 # Small git utilities
brew install git-lfs                    # Git extension for versioning large files
brew install git-quick-stats            # Simple and efficient way to access statistics in git.
brew install github/gh/gh               # GitHub command-line tool
brew install glow                       # Render markdown on the CLI
brew install go                         # The Go programming language
brew install gource                     # Version Control Visualization Tool
brew install gpg                        # GNU Pretty Good Privacy (PGP)
brew install grex                       # Command-line tool for generating regular expressions
brew install gsl                        # Numerical library for C and C++
brew install gnu-sed                    # GNU implementation of the famous stream editor
brew install highlight                  # Convert source code to formatted text with syntax highlighting
brew install htop                       # Improved top
brew install httpie                     # User-friendly cURL replacement (command-line HTTP client
brew install hub                        # Add GitHub support to git on the command-line
brew install icu4c                      # C/C++ and Java libraries for Unicode and globalization
brew install imagemagick --with-fontconfig # Tools and libraries to manipulate images in many formats
brew install imagesnap                  # Tool to capture still images from an iSight or other video source
brew install jless                      # Command-line pager for JSON data
brew install jpeg                       # Image manipulation library
brew install lazygit                    # Simple terminal UI for git commands
brew install libdvdcss                  # Access DVDs as block devices without the decryption
brew install libpng                     # Library for manipulating PNG images
brew install lua                        # Powerful, lightweight programming language
brew install luarocks                   # LuaRocks is the package manager for Lua modules.
brew install lynx                       # Text-based web browser
brew install m-cli                      # Swiss Army Knife for macOS
brew install mas                        # Mac App Store command-line interface
brew install memcached                  # High performance, distributed memory object caching system
brew install mongodb                    # High-performance, schema-free, document-oriented database
brew install multimarkdown              # Turn marked-up plain text into well-formatted documents
brew install mysql                      # Open source relational database management system
brew install ncdu                       # NCurses Disk Usage
brew install neovim --HEAD              # NeoVim
brew install ossp-uuid                  # ISO-C API and CLI for generating UUIDs
brew install pandoc                     # Swiss-army knife of markup format conversion
brew install pango                      # Framework for layout and rendering of i18n text
brew install pass                       # Password manager
brew install peco                       # Simplistic interactive filtering tool
brew install pkg-config                 # Manage compile and link flags for libraries
brew install python                     # Interpreted, interactive, object-oriented programming language
brew install rabbitmq                   # Messaging broker
brew install rbenv                      # Ruby version manager
brew install rbenv-aliases              # Make aliases for Ruby versions
brew install rbenv-vars                 # Safely sets global and per-project environment variables
brew install readline                   # Library for command-line editing
brew install reattach-to-user-namespace # Reattach process (e.g., tmux) to background
brew install redis                      # Persistent key-value database, with built-in net interface
brew install remarshal                  # Convert between TOML, YAML and JSON ➜ toml2yaml -i test.toml -o test.yml; json2toml, yaml2toml etc.
brew install ripgrep                    # Search tool like grep and The Silver Searcher ➜ rg
brew install rsync                      # Utility that provides fast incremental file transfer
brew install ruby                       # Powerful, clean, object-oriented scripting language
brew install ruby-build                 # Install various Ruby versions and implementations
brew install scala                      # JVM-based programming language
brew install slugify                    # Convert filenames and directories to a web friendly format
brew install sqlite                     # Command-line interface for SQLite
brew install ssh-copy-id                # Add a public key to a remote machine's authorized_keys file
brew install startship                  # Cross-shell prompt for astronauts
brew install the_silver_searcher        # Code-search similar to ack ➜ ag
brew install tmate                      # Instant terminal sharing
brew install tmux                       # Terminal multiplexer
brew install tmuxinator                 # Create and manage tmux sessions easily
brew install tree                       # Display directories as trees (with optional color/HTML output)
brew install universal-ctags/universal-ctags/universal-ctags --HEAD # A maintained ctag implementation
brew install urlview                    # URL extractor/launcher (needed for tmux-urlview)
brew install vale                       # Syntax-aware linter for prose
brew install watchman                   # Watch files and take action when they change
brew install wget                       # Internet file retriever
brew install yarn                       # JavaScript package manager
brew install youtube-dl                 # Download YouTube videos from the command-line
brew install z                          # Tracks most-used directories to make cd smarter
brew install zeromq                     # High-performance, asynchronous messaging library
brew install zsh                        # UNIX shell (command interpreter)
brew install zsh-syntax-highlighting    # Fish shell like syntax highlighting for zsh

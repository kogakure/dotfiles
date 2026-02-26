# Only source this once.
if [ -n "$SESSION_VARS_SOURCED" ]; then return; fi
export SESSION_VARS_SOURCED=1

# General
export KEYTIMEOUT="1"

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export GIT_EDITOR="nvim"
fi

# XDG base directory specification
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# SSH
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

# fd
FD_OPTIONS="--follow --exclude .git --exclude node_modules"

# fzf
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_CTRL_R_OPTS="--reverse"
export FZF_CTRL_T_COMMAND="git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS="--no-height"
export FZF_TMUX="1"
export FZF_TMUX_OPTS="-p"

# OpenSSL
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

# Man
export MANPATH="/usr/local/man:$MANPATH"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# tmux plugins
export PATH=$HOME/.tmux/plugins/tmux-nvr/bin:$PATH
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

# Personal
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="$HOME/.dotfiles/private/bin:$PATH"

# Homebrew
export PATH="$(brew --prefix)/bin:$PATH"
export PATH="$(brew --prefix)/sbin:$PATH"
export PATH="$(brew --prefix)/whalebrew/bin:$PATH"

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

# Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# System
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

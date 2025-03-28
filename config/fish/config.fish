# Use wezterm.terminfo
# curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -

# *** *** Key Bindings *** ***

# Enable vi-mode key bindings
fish_vi_key_bindings

# (r)everse history search
bind -M viins '^r' fzf-history-widget

# (f)ile / (t)
bind -M viins '^f' fzf-file-widget

# (z) jump
bind -M viins '^z' fzf-cd-widget

# *** *** Session Variables *** ***

# set TERM wezterm

# General
set -x KEYTIMEOUT 1

if command -v nvim >/dev/null 2>&1
    set -x EDITOR nvim
    set -x GIT_EDITOR nvim
end

# Determine Homebrew prefix based on architecture
if test (uname -m) = arm64
    set brew_prefix /opt/homebrew
else
    set brew_prefix /usr/local
end

# Check if essential commands are in PATH, if not add them
if not command -v podman >/dev/null 2>&1 || not command -v brew >/dev/null 2>&1
    # Add Homebrew to PATH if not already there
    if not contains $brew_prefix/bin $PATH
        set -x PATH $brew_prefix/bin $PATH
    end
end

# Initialize Homebrew environment
eval "$($brew_prefix/bin/brew shellenv)"

set -x HOMEBREW_NO_AUTO_UPDATE 1

# XDG base directory specification
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# GPG
set -gx GPG_TTY (tty)

# SSH
set -x SSH_AUTH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# fd
set FD_OPTIONS "--follow --exclude .git --exclude node_modules"

# Make Podman work with LazyDocker
set -x DOCKER_HOST "unix://"(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')

# fzf
set -x FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS --color=never --hidden"
set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -50'"
set -x FZF_CTRL_R_OPTS --reverse
set -x FZF_CTRL_T_COMMAND "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
set -x FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
set -x FZF_DEFAULT_COMMAND "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
set -x FZF_DEFAULT_OPTS --no-height
set -x FZF_TMUX 1
set -x FZF_TMUX_OPTS -p

# OpenSSL
set -x LDFLAGS "-L$brew_prefix/opt/openssl/lib"
set -x CPPFLAGS "-I$brew_prefix/opt/openssl/include"
set -x PKG_CONFIG_PATH "$brew_prefix/opt/openssl/lib/pkgconfig"

# Man
set -x MANPATH /usr/local/man $MANPATH

# Volta
set -x VOLTA_HOME $HOME/.volta

# *** *** Session Paths *** ***

# asdf
set -l asdf_path (brew --prefix asdf)
if test -f $asdf_path/libexec/asdf.fish
    source $asdf_path/libexec/asdf.fish
    set -x PATH $HOME/.asdf/shims $PATH
end

# Volta
set -x PATH $PATH $VOLTA_HOME/bin

# Bun
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH "$BUN_INSTALL/bin" $PATH

# Rust
set -x PATH $PATH $HOME/.cargo/bin
set -x PATH $PATH $HOME/.local/share/../bin

# tmux plugins
set -x PATH $PATH $HOME/.tmux/plugins/tmux-nvr/bin
set -x PATH $PATH $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin

# Personal
set -x PATH $PATH $HOME/.dotfiles/bin
set -x PATH $PATH $HOME/.dotfiles/private/bin

# System
set -x PATH $PATH /usr/bin
set -x PATH $PATH /usr/local/bin
set -x PATH $PATH /usr/local/sbin

# Emacs
set -x PATH $PATH $HOME/.config/emacs/bin

# Make sure asdf comes first
set -x PATH $HOME/.asdf/shims $PATH

# Stable Diffusion Webui
# set VIRTUAL_ENV $HOME/Code/AI/stable-diffusion-webui/venv

# *** *** Tools *** ***

# GitHub CLI completion
if command -v gh >/dev/null 2>&1
    eval "$(gh completion -s fish)"
end

# fzf
fzf --fish | source

# Direnv
direnv hook fish | source

# Zoxide
zoxide init fish | source

# Atuin
atuin init fish | source

# Starship
starship init fish | source

# *** *** Aliases *** ***

alias reload 'exec fish'

# Folders/Lists
alias ... 'cd ../..'
alias cd.. 'cd ..'
alias ls 'eza --git --group-directories-first --icons'
alias ll 'eza -l --git --group-directories-first --icons'
alias lt 'eza --git --group-directories-first --icons --tree'
alias mkdir 'mkdir -p'
alias dotfiles 'cd $HOME/.dotfiles'
alias icloud 'cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs'
alias dropbox 'cd $HOME/Dropbox'

# pnpm
alias pn pnpm
alias px pnpx

# Git
alias ga 'git add'
alias gb 'git branch'
alias gba 'git branch -a'
alias gc 'git commit -v'
alias gca 'git commit -v -a'
alias gcam 'git commit --amend'
alias gcan 'git commit --amend --no-edit'
alias gd 'git diff -- . ":(exclude)yarn.lock"'
alias gdc 'git diff --cached' # Show changes in next commit (differences between index and last commit)
alias gdh 'git diff head' # Show difference between files in working tree and last commit
alias gdt 'git difftool'
alias gfa 'git fetch --all'
alias gg 'git log'
alias ghi 'git hist'
alias gl 'git pull'
alias glr 'git pull --rebase'
alias glu 'git config user.name "Stefan Imhoff" && git config user.email "gpg@kogakure.8shield.net" && git config user.signingkey "7A7253E8!"'
alias glx 'git config user.name "Stefan Imhoff" && git config user.email "stefan.imhoff@xing.com" && git config user.signingkey "73C3E2E3!"'
alias gmb 'git merge-base master HEAD'
alias gp 'git push'
alias gpf 'git push --force-with-lease'
alias gpp 'PATCHNAME=`git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/"`-`date "+%Y-%m-%d-%H%M.patch"`; git diff --full-index master > ../patches/$PATCHNAME'
alias gpu 'git push -u origin HEAD'
alias gpv 'git push --no-verify'
alias grb 'git rebase master'
alias grbc 'git rebase --continue'
alias grbi 'git rebase -i '
alias grbs 'git rebase --skip'
alias gru 'git remote update'
alias gsb 'git show-branch'
alias gsl 'git submodule foreach git pull'
alias gst 'git status -sb'
alias gsu 'git submodule update'
alias gu 'git up'
alias gw 'git whatchanged'
alias gw 'git worktree'
alias gwa 'git worktree add' # <folder> <branch/hash>
alias gwl 'git worktree list'
alias gwp 'git whatchanged -p'
alias gwr 'git worktree remove' # <path/name>
alias lg lazygit

# Vim/Neovim
alias v vim

# Emacs
alias emacs "emacs -nw"

if type nvim >/dev/null 2>&1
    alias vim nvim
end

# Homebrew
alias bi 'brew install'

# TMUX
alias t tmux
alias ta 'tmux attach'

# Can't remember the fork name
alias youtube-dl yt-dlp

# iA Writer
alias ia 'open $1 -a /Applications/iA\ Writer.app'

# Recursively delete `.DS_Store` files
alias cleanup 'find . -type f -name "*.DS_Store" -ls -delete'

# Clear the screen
alias c clear

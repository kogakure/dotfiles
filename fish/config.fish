if status is-interactive
    # Commands to run in interactive sessions can go here
end

# *** *** Configuration *** ***

# Base16 Shell
# if status --is-interactive
#     set BASE16_SHELL "$HOME/.config/base16-shell/"
#     source "$BASE16_SHELL/profile_helper.fish"
# end

# Use wezterm.terminfo
# curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -
set TERM wezterm

# SSH
set -x SSH_AUTH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# Neovim as default editor
set -U EDITOR nvim

set PATH /opt/homebrew/bin $PATH
set PATH /opt/homebrew/sbin $PATH
set PATH /opt/homebrew/opt/libomp/bin $PATH
set PATH /opt/homebrew/opt/llvm/bin $PATH
set PATH /usr/local/sbin $PATH
set PATH ~/.dotfiles/bin $PATH
set PATH ~/.dotfiles/private/bin $PATH
set PATH ~/.local/bin $PATH
set PATH ~/.asdf/shims $PATH

set -x LIBRARY_PATH (brew --prefix)/opt/libiconv/lib
set -x CPATH (brew --prefix)/opt/libiconv/include
set -x PKG_CONFIG_PATH (brew --prefix)/opt/libiconv/lib/pkgconfig

# Homebrew Command Not Found
set HB_CNF_HANDLER (brew --repository)"/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
if test -f $HB_CNF_HANDLER
    source $HB_CNF_HANDLER
end

# Set .config folder
set --export XDG_CONFIG_HOME "$HOME/.config"

set --export KEYTIMEOUT 1
set --export RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/ripgreprc
set --export GIT_EDITOR nvim
set --export EDITOR nvim

# Stable Diffusion Webui
set VIRTUAL_ENV $HOME/Code/AI/stable-diffusion-webui/venv

# Atuin
atuin init fish | source

# Direnv
direnv hook fish | source

# FZF
set FD_OPTIONS "--follow --exclude .git --exclude node_modules"

set --export FZF_DEFAULT_COMMAND "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
set --export FZF_DEFAULT_OPTS --no-height

set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set --export FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

set --export FZF_CTRL_R_OPTS --reverse
set --export FZF_TMUX_OPTS -p

set --export FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS --color=never --hidden"
set --export FZF_ALT_C_OPTS "--preview 'tree -C {} | head -50'"

set --export FZF_COMPLETE 0

# Nix
set nix_path /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if test -f $nix_path
    bass source $nix_path
end

set --export PATH /run/current-system/sw/bin $PATH
set --export PATH /etc/profiles/per-user/$USER/bin $PATH

# Zoxide
zoxide init fish | source

# Rust
set --export PATH "$HOME/.cargo/bin:$PATH"

# TMUX
if set -q TMUX
    set --export NVIM_LISTEN_ADDRESS (tmux show-environment -s NVIM_LISTEN_ADDRESS 2> /dev/null)
else
    set --export NVIM_LISTEN_ADDRESS /tmp/nvimsocket
end

set --export PATH $HOME/.tmux/plugins/tmux-nvr/bin $PATH
set --export PATH $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin $PATH

# BasicTex
set --export PATH /Library/TeX/texbin $PATH

# Man
set --export MANPATH "/usr/local/man:$MANPATH"

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm/"
set -gx PATH "$PNPM_HOME" $PATH

# Enable vi-mode key bindings
fish_vi_key_bindings

# (r)everse history search
bind -M viins '^r' fzf-history-widget

# (f)ile / (t)
bind -M viins '^f' fzf-file-widget

# (z) jump
bind -M viins '^z' fzf-cd-widget

# *** *** Aliases *** ***

# Fish
alias reload 'exec fish'

# Folders/Lists
alias ... 'cd ../..'
alias cd.. 'cd ..'
alias ls 'eza --git --group-directories-first --icons'
alias ll 'eza -l --git --group-directories-first --icons'
alias lt 'eza --git --group-directories-first --icons --tree'
alias mkdir 'mkdir -p'
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
alias gd 'git diff -- . ":(exclude)yarn.lock"' # Show differences between index and working tree
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
alias gcrb 'git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs  git checkout '

# Vim/Neovim
alias v vim

if type nvim >/dev/null 2>&1
    alias vim nvim
end

# TMUX
alias t tmux
alias mux tmuxinator
alias ms 'mux start'
alias ta 'tmux attach'

# Nix
alias nxs 'darwin-rebuild switch --flake ~/.dotfiles/nix'

# Bat
alias cat bat

# TLDR
alias tldrf 'tldr --list --single-column | fzf --preview "tldr --color=always {1}" --preview-window=right,70% | xargs tldr'

# Dotfiles Folder
alias dotfiles 'cd ~/.dotfiles'

# iCloud
alias icloud "cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
#
# Clear the screen
alias c clear

# GitHub Copilot CLI
alias cpw copilot_what-the-shell
alias cpg copilot_git-assist
alias cpgh copilot_github-assist
alias wts copilot_what-the-shell

# Nvim
alias :GoToFile "nvim +GoToFile"
alias :Grep "nvim +Grep"

# Prompt
starship init fish | source

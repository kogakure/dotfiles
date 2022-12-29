if status is-interactive
    # Commands to run in interactive sessions can go here
end

# *** *** Configuration *** ***

# asdf Version Manager
source /usr/local/opt/asdf/libexec/asdf.fish

# Neovim as default editor
set -U EDITOR nvim

# *** *** Aliases *** ***

# Fish
alias reload 'exec fish'

# Folders/Lists
alias ... 'cd ../..'
alias cd.. 'cd ..'
alias ls 'exa --git --group-directories-first --icons'
alias ll 'exa -l --git --group-directories-first --icons'
alias lla 'll -a'
alias mkdir 'mkdir -p'

# Git
alias gl 'git pull'
alias glr 'git pull --rebase'
alias glu 'git config user.name "Stefan Imhoff" && git config user.email "stefan@imhoff.name";'
alias glx 'git config user.name "Stefan Imhoff" && git config user.email "stefan.imhoff@xing.com";'
alias gp 'git push'
alias gpf 'git push --force-with-lease'
alias gw 'git whatchanged'
alias gwp 'git whatchanged -p'
alias lg 'lazygit'

# Vim/Neovim
alias v "vim"

if type nvim > /dev/null 2>&1
  alias vim 'nvim'
end

# TMUX
alias t 'tmux'
alias mux 'tmuxinator'
alias ms 'mux start'

# Bat
alias cat 'bat'

# Dotfiles Folder
alias dotfiles 'cd ~/.dotfiles'

# iCloud
alias icloud "cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
#
# Clear the screen
alias c "clear"

# Prompt
starship init fish | source

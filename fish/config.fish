if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Prompt
starship init fish | source

# asdf Version Manager
source /usr/local/opt/asdf/libexec/asdf.fish

# Neovim as default editor
set -U EDITOR nvim

alias v "vim"

if type nvim > /dev/null 2>&1
  alias vim 'nvim'
end

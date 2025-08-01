# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTCONTROL=erasedups:ignorespace
HISTFILESIZE=100000
HISTSIZE=10000
HISTTIMEFORMAT="%F %T "

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

# Bash completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && source "/opt/homebrew/etc/profile.d/bash_completion.sh"

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# *** *** Tools *** ***

# GitHub CLI completion
if command -v gh >/dev/null 2>&1; then
	eval "$(gh completion -s bash)"
fi

# fzf
if command -v fzf >/dev/null 2>&1 && [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
	eval "$(fzf --bash)"
fi

# Direnv
if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook bash)"
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init bash)"
fi

# Atuin
if command -v atuin >/dev/null 2>&1; then
	eval "$(atuin init bash)"
fi

# Starship
if command -v starship >/dev/null 2>&1 && [[ $TERM != "dumb" ]]; then
	eval "$(starship init bash)"
	PS1="$(/opt/homebrew/bin/starship prompt)"
fi

# *** *** Aliases *** ***

alias reload="source $HOME/.bashrc"
source "$HOME/.aliases"

# *** *** Functions *** ***

for file in ~/.functions/*.sh; do
	source "$file"
done

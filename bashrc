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

# The nine tool hooks are generated from shell/hooks.spec, so bash, zsh and fish
# cannot drift apart again. Edit the spec and run `just generate`.
#
# The starship block here used to follow `starship init bash` with a one-shot
# PS1="$(/opt/homebrew/bin/starship prompt)", which replaced the dynamic prompt
# it had just installed with a single frozen render — and starship is
# mise-managed on this machine, so that hardcoded path does not exist and every
# interactive bash login printed "No such file or directory". Both gone.
# shellcheck source=generated/hooks.bash
[[ -r "$HOME/.hooks.bash" ]] && source "$HOME/.hooks.bash"

# *** *** Aliases *** ***

alias reload='source "$HOME/.bashrc"'
source "$HOME/.aliases"

# *** *** Functions *** ***

# An unmatched glob expands to itself, so guard before sourcing — otherwise an
# empty ~/.functions/ makes every shell start try to source a literal `*.sh`.
for file in ~/.functions/*.sh; do
    [ -e "$file" ] || continue
    # shellcheck source=/dev/null  # user-supplied files, not resolvable statically
    source "$file"
done

[[ -r "$HOME/.dotfiles/private/shell/otto-completion.bash" ]] && source "$HOME/.dotfiles/private/shell/otto-completion.bash"

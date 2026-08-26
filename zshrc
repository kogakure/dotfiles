autoload -Uz compinit
compinit

CASE_SENSITIVE="true"     # Case-sensitive completion
DISABLE_AUTO_TITLE="true" # Disable auto-setting terminal title
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7,bg=bold,underline"

# *** *** Key Bindings *** ***

bindkey -v
bindkey -M viins '^r' fzf-history-widget # (r)everse history search
bindkey -M viins '^f' fzf-file-widget    # (f)ile / (t)
bindkey -M viins '^z' fzf-cd-widget      # (z) jump

# *** *** Tools *** ***

# The nine tool hooks are generated from shell/hooks.spec, so bash, zsh and fish
# cannot drift apart again. Edit the spec and run `just generate`.
#
# This file used three different `command -v` idioms for the same job —
# `&>/dev/null` everywhere except worktrunk, which used bash's. One spec, one
# idiom.
[[ -r "$HOME/.hooks.zsh" ]] && source "$HOME/.hooks.zsh"

# Antidote
source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# *** *** Aliases *** ***

alias reload="source $HOME/.zshrc"
source "$HOME/.aliases"

# *** *** Functions *** ***

# (N) is zsh's per-pattern nullglob. Without it an empty ~/.functions/ is a hard
# error under the default `nomatch` — unlike bash, where the glob would merely
# expand to itself. The -e test then skips any dangling symlink.
for file in ~/.functions/*.sh(N); do
    [ -e "$file" ] || continue
    source "$file"
done

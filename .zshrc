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

# asdf
if command -v brew &>/dev/null && [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"

  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc" ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
  fi
fi

# GitHub CLI completion
if command -v gh &>/dev/null; then
  eval "$(gh completion -s zsh)"
fi

# fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Atuin
if command -v atuin &>/dev/null; then
	eval "$(atuin init zsh)"
fi

# Starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Antidote
source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# *** *** Aliases *** ***

alias reload="source $HOME/.zshrc"
source "$HOME/.aliases"

# *** *** Functions *** ***

for file in ~/.functions/*.sh; do
  source "$file"
done

# Fish-specific configuration only.
#
# Environment, PATH, aliases and tool hooks are generated from shell/*.spec —
# the same spec that produces generated/session-variables.sh for bash and zsh.
# Edit the spec and run `just generate`; do not add any of that back here.
#
# Env, PATH and aliases go to conf.d/{00-env,10-path,20-aliases}.fish, which
# fish sources before this file. The hooks do not: they are sourced at the
# bottom of this file, because conf.d/z.fish — the vendored jethrokuan/z plugin
# — defines its own `z` and would shadow zoxide's if the hooks ran first. They
# sat at the bottom of this file before the refactor for the same reason.

# Use wezterm.terminfo
# curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -

# *** *** Key Bindings *** ***

# Enable vi-mode key bindings
fish_vi_key_bindings

# Set before the hooks are sourced below, so `fzf --fish` still installs its own
# bindings afterwards — exactly the order these two had before the refactor.

# (r)everse history search
bind -M viins '^r' fzf-history-widget

# (f)ile / (t)
bind -M viins '^f' fzf-file-widget

# (z) jump
bind -M viins '^z' fzf-cd-widget

# *** *** Aliases *** ***

# Genuinely shell-specific, so not in shell/aliases.spec: bash and zsh
# re-source their rc file instead.
alias reload 'exec fish'

# *** *** Tools *** ***

# Generated from shell/hooks.spec. Last, so zoxide's `z` beats conf.d/z.fish's
# and `fzf --fish` gets the final say on its own key bindings.
if test -r "$HOME/.hooks.fish"
    source "$HOME/.hooks.fish"
end

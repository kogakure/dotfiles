#!/bin/bash
#
# Where tpm installs tmux plugins.
#
# One function, because two scripts asked the same question and both got it
# wrong: bin/dotfiles-doctor reported all 17 declared plugins as missing on
# every host, and told you to run an installer that would have cloned a second
# copy into the directory tmux does not read (SI-124).
#
# tpm is XDG-aware. From its own `tpm` entry point:
#
#   set_default_tpm_path() {
#       local xdg_tmux_path="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
#       local tpm_path="$DEFAULT_TPM_PATH"
#       if [ -f "$xdg_tmux_path/tmux.conf" ]; then
#           tpm_path="$xdg_tmux_path/plugins/"
#       fi
#       tmux set-environment -g "$DEFAULT_TPM_ENV_VAR_NAME" "$tpm_path"
#   }
#
# install.conf.yaml globs config/* into ~/.config/, so ~/.config/tmux/tmux.conf
# exists on every machine here and the XDG branch is always the one taken.
# ~/.tmux/plugins therefore holds tpm itself and nothing else, which is correct
# and was read as breakage.
#
# WHY NOT ASK TMUX
#
# The authoritative answer is `tmux show-environment -g
# TMUX_PLUGIN_MANAGER_PATH`, but reaching it costs `tmux start-server` when no
# server is running — a mutation, and bin/dotfiles-doctor is structurally
# read-only. Replicating the rule is exact rather than approximate: it is the
# same two-branch condition tpm evaluates, over the same two inputs.
#
# Pure: both roots are arguments, so `just lint unit` can drive both layouts
# against fixtures on a host that has neither. The same pure/impure seam as
# bin/lib/shells.sh.

# tmux_plugin_path <config-home> <home>
#
# Echoes the directory tpm installs into. No trailing slash — tpm's own value
# carries one, and callers here join with "/$name".
tmux_plugin_path() {
    local config_home="${1:-}" home="${2:-}"

    if [ -f "$config_home/tmux/tmux.conf" ]; then
        printf '%s\n' "$config_home/tmux/plugins"
    else
        printf '%s\n' "$home/.tmux/plugins"
    fi
}

# The same question against this machine, for callers with nothing to override.
tmux_plugin_path_here() {
    tmux_plugin_path "${XDG_CONFIG_HOME:-$HOME/.config}" "$HOME"
}

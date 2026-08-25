#!/bin/bash
#
# Helpers for registering a login shell in /etc/shells.
#
# Sourced by setup.sh and by bin/dotfiles-lint's `unit` check, which is the
# whole point of the split: the transformation below is pure and takes the
# shells file as an argument, so the lint suite can exercise it against a
# fixture with no root and no /etc/shells. Only register_login_shell touches
# the real file, and the tests never call it.
#
# Sourcing this file must stay free of side effects — it defines functions and
# nothing else.

# Print what a shells file should contain once $1 is registered in it:
#
#   - at most one entry for $1, keeping the first occurrence in place
#   - the entry appended at the end when it is absent entirely
#   - every other line, and the original ordering, untouched
#
# Usage: shells_file_desired <shell-path> <shells-file>
shells_file_desired() {
    local shell_path=$1 shells_file=$2
    awk -v line="$shell_path" '
        $0 == line { if (seen++) next }
        { print }
        END { if (!seen) print line }
    ' "$shells_file"
}

# Register $1 as a login shell in $2 (default /etc/shells), collapsing any
# duplicates a previous run left behind.
#
# This used to be two byte-identical `tee -a` calls, so every setup.sh run
# appended the path a second time and the file grew without bound — four fish
# entries had accumulated across three machines. Writing the whole desired file
# rather than appending is what makes it idempotent: the second run computes
# the same content, finds no difference, and does nothing.
#
# Usage: register_login_shell <shell-path> [shells-file]
register_login_shell() {
    local shell_path=$1 shells_file=${2:-/etc/shells} desired tmp

    desired=$(shells_file_desired "$shell_path" "$shells_file") || return 1

    if [ "$desired" = "$(cat "$shells_file")" ]; then
        echo "${shell_path} already registered in ${shells_file}"
        return 0
    fi

    echo "Registering ${shell_path} in ${shells_file}"
    tmp=$(mktemp) || return 1
    printf '%s\n' "$desired" >"$tmp"
    # shellcheck disable=SC2024  # the redirect reads our own mktemp file; only
    # the write to the shells file needs privileges, which is what tee does.
    sudo tee "$shells_file" <"$tmp" >/dev/null
    rm -f "$tmp"
}

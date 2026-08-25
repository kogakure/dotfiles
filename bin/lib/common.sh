#!/bin/bash
#
# Entry point for the bin/ shared library. Every bash script in bin/ that uses
# a shared helper sources this one file; it sources the rest.
#
# THIS FILE SETS NO SHELL OPTION.
#
# `set -euo pipefail` belongs in the script it applies to, on the line above the
# source line, where a reader can see it. Setting it here would apply it from
# the source line onward in a dozen scripts at once, invisibly — and it would
# break four of them. bin/dotfiles-lint and bin/preferences-restore run without
# -e deliberately, and bash 3.2 (the /bin/bash macOS ships, which runs all of
# these) treats an empty array as unbound under -u, so -u is fatal to the three
# sbx-* launchers on their default invocation. See docs/guardrails.md.
#
# The contract, the same one bin/lib/shells.sh states: sourcing this file and
# its siblings defines functions and _DL_-prefixed constants. It sets no
# option, writes no file, prints nothing, and touches no other name.
#
# Usage, from any script in bin/:
#
#   set -euo pipefail
#
#   # shellcheck source-path=SCRIPTDIR
#   # shellcheck source=lib/common.sh
#   . "$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh" || exit 1

_DL_LIB=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd) || {
    echo "dotfiles: cannot resolve bin/lib — aborting." >&2
    return 1
}

# The repository root, from this file's own location rather than the caller's
# cwd or a ~/.dotfiles literal, so a clone at any path works. Pure string
# surgery: bin/lib -> strip /lib -> strip /bin.
_DL_ROOT=${_DL_LIB%/*/*}

# shellcheck source-path=SCRIPTDIR
# shellcheck source=log.sh
. "$_DL_LIB/log.sh"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=util.sh
. "$_DL_LIB/util.sh"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=profile.sh
. "$_DL_LIB/profile.sh"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=sync.sh
. "$_DL_LIB/sync.sh"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=preferences.sh
. "$_DL_LIB/preferences.sh"

# bin/lib/shells.sh is deliberately absent from that list: setup.sh is its only
# caller, and register_login_shell writes to /etc/shells behind sudo. That does
# not belong in the namespace of every script in bin/.

# The five variables that carry flags from bin/dotfiles-backup down to the
# scripts it drives. Each is a 0/1 flag; `:=` means an exported value from a
# parent wins, and a direct invocation gets the default. A sub-script's own
# argument parser then overrides whatever it inherited, so argv always wins.
#
# An exported channel rather than forwarded argv: assembling a possibly-empty
# flag array is a fatal unbound-variable error under bash 3.2 + `set -u`, and
# this way adding a sub-script needs no plumbing in the aggregator.
#
# Usage: dotfiles_flags_init
dotfiles_flags_init() {
    : "${DOTFILES_DRY_RUN:=0}"
    : "${DOTFILES_PRUNE:=0}"
    : "${DOTFILES_ASSUME_YES:=0}"
    : "${DOTFILES_ALLOW_DIRTY:=0}"
    : "${DOTFILES_PRIVATE_GATE:=}"
}

# Print the command instead of running it under --dry-run. Every mutation in a
# migrated script goes through this, so --dry-run cannot miss one. Lifted from
# bin/macos-settings:41, which is where the idiom was established.
#
# Usage: run <command> [arg...]
run() {
    if [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ]; then
        printf '  %s\n' "$*"
    else
        "$@"
    fi
}

# Write stdin to <dest>, or report it under --dry-run.
#
# run() cannot wrap a redirect, so a `cat >file <<EOF` heredoc needs its own
# helper — and it needs one, because the backup manifests were exactly the
# mutation that slipped past --dry-run when every `cp` had been accounted for.
# The heredoc is still consumed in dry-run mode so the caller's pipeline does
# not see EPIPE.
#
# Usage: write_file <dest> <<EOF ... EOF
write_file() {
    local dest=$1
    if [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ]; then
        cat >/dev/null
        printf '  write %s\n' "$dest"
    else
        cat >"$dest"
    fi
}

# So that `. lib/common.sh || exit 1` in the caller means "the library failed to
# load", not "the last function definition happened to return non-zero".
true

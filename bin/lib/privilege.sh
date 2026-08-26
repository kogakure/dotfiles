#!/bin/bash
#
# One credential prompt, one background refresher, one teardown.
#
# setup.sh and bin/update each carried their own copy of the same keep-alive
# loop, and they had already drifted:
#
#   setup.sh:30-37   primed at line 30, captured $! into SUDO_KEEPALIVE_PID and
#                    killed it from `trap cleanup EXIT`. Correct, but it primed
#                    before argument parsing, so `--dry-run` prompted for a
#                    password before deciding to change nothing.
#   bin/update:3-11  captured no PID and had no trap at all. The loop's own
#                    `kill -0 "$$"` check is the only thing that stopped it, and
#                    it only runs after the sleep — so every interrupted run
#                    leaked a refresher for up to the poll interval.
#
# Sourced by setup.sh and bin/update, not by bin/lib/common.sh. Same reasoning
# as bin/lib/shells.sh: a helper that escalates privilege does not belong in the
# namespace of every script in bin/. Requires bin/lib/log.sh to be sourced
# first.
#
# Sourcing this file must stay free of side effects — it defines functions and
# _DL_-prefixed state, sets no shell option, and prints nothing.

# The refresher's PID, empty until privilege_keepalive starts one. Empty rather
# than unset so privilege_release can read it under `set -u`.
_DL_PRIVILEGE_PID=""

# Seconds between refreshes. The credential timestamp lasts five minutes by
# default, so this has four refreshes of headroom. setup.sh used 60 and
# bin/update used 30 for no stated reason; 60 is the survivor.
_DL_PRIVILEGE_INTERVAL=60

# The single point where privilege is actually exercised.
#
# A function rather than an inline command so bin/dotfiles-lint's `unit` check
# can redefine it as `true` and drive the whole prime/keepalive/release
# lifecycle with no password, no escalation and no sudoers involvement. That is
# the same pure/impure seam bin/lib/shells.sh draws between
# shells_file_desired and register_login_shell — everything testable is on this
# side of it, and the tests never call the real thing.
#
# Usage: privilege_refresh
privilege_refresh() {
    sudo -n true
}

# Ask for the password once, up front, so a long unattended run does not stop
# for it halfway through.
#
# Inert under --dry-run, which is the point: the acceptance criterion is that a
# dry run never prompts, and priming is itself a prompt. The check is written
# out rather than delegated to common.sh's run(), because this file is sourced
# on its own — by the unit check, and by callers before common.sh in one case —
# and must not depend on it.
#
# Usage: privilege_prime
privilege_prime() {
    if [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ]; then
        log_skip "dry run: not asking for the administrator password"
        return 0
    fi
    sudo -v
}

# Keep the credential timestamp warm until privilege_release, or until the
# parent process is gone.
#
# Both stopping conditions are kept on purpose. The trap is what makes teardown
# prompt; the loop's own `kill -0 "$$"` is the backstop for the case the trap
# cannot cover — a SIGKILL'd parent, which runs no trap at all. Relying on the
# backstop alone is what bin/update did, and it is why an interrupted run leaked
# a refresher for up to a poll interval.
#
# Starting twice is a no-op rather than a second loop.
#
# Usage: privilege_keepalive
privilege_keepalive() {
    [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] && return 0
    [ -n "$_DL_PRIVILEGE_PID" ] && return 0

    while true; do
        privilege_refresh
        sleep "$_DL_PRIVILEGE_INTERVAL"
        kill -0 "$$" 2>/dev/null || exit
    done 2>/dev/null &

    _DL_PRIVILEGE_PID=$!
    return 0
}

# Stop the refresher.
#
# Safe to call when none was started, and safe to call twice — teardown runs
# from a trap, and a trap that can fail is a trap that decides the script's exit
# status. Clearing the PID after the kill is what makes the second call a no-op.
#
# Usage: privilege_release
privilege_release() {
    if [ -n "$_DL_PRIVILEGE_PID" ]; then
        kill "$_DL_PRIVILEGE_PID" 2>/dev/null
        _DL_PRIVILEGE_PID=""
    fi
    return 0
}

# So that `. lib/privilege.sh || exit 1` means "the library failed to load".
true

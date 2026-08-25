#!/bin/bash
#
# The work/personal machine profile shared by the agent backup and restore
# scripts.
#
# The lookup was written out verbatim four times — claude-backup:21,
# claude-restore:21, codex-backup:21, codex-restore:20 — and validated in only
# one of them. So a ~/.agentic-profile holding a typo silently created
# private/claude/<typo>/ and backed the machine up into it, where nothing would
# ever restore from. agentic_profile below cannot be used without validating,
# which is the point of the split.

# Where the profile is stored, and the legacy location still honoured as a
# fallback. Functions rather than literals so agentic-set-profile, which writes
# the file, and agentic_profile, which reads it, cannot drift apart.
#
# Usage: profile_file / profile_legacy_file
profile_file() { printf '%s\n' "$HOME/.agentic-profile"; }
profile_legacy_file() { printf '%s\n' "$HOME/.machine-profile"; }

# Pure. Usage: profile_is_valid <value>
profile_is_valid() {
    case $1 in
        work | personal) return 0 ;;
        *) return 1 ;;
    esac
}

# Print the first non-empty first line among the given files, or "personal".
#
# `read -r` rather than `cat`: it takes line one and, with the default IFS,
# trims surrounding blanks, so a file written by hand as "  work  " or with a
# trailing newline resolves instead of failing validation. The four copies this
# replaces used `cat`, so any of that would have produced a bogus directory.
#
# Pure — every path is an argument, so `just lint unit` exercises it against
# fixtures with no dependence on the real $HOME.
#
# Usage: profile_read <file>...
profile_read() {
    local file value
    for file in "$@"; do
        [ -f "$file" ] || continue
        read -r value <"$file" || value=""
        [ -n "$value" ] || continue
        printf '%s\n' "$value"
        return 0
    done
    printf '%s\n' personal
}

# This machine's profile, from ~/.agentic-profile with a fallback to the legacy
# ~/.machine-profile.
#
# Returns non-zero on an invalid value rather than exiting: callers use it as
# `PROFILE=$(agentic_profile) || exit 1`, and an `exit` inside a command
# substitution would only leave the subshell.
#
# Usage: agentic_profile
agentic_profile() {
    local value
    value=$(profile_read "$(profile_file)" "$(profile_legacy_file)")
    if ! profile_is_valid "$value"; then
        log_err "agentic profile must be 'work' or 'personal', got '$value'"
        log_err "Set it with: agentic-set-profile work|personal"
        return 1
    fi
    printf '%s\n' "$value"
}

# Validate a profile named on the command line, e.g. codex-restore's optional
# source-profile argument. Absorbs codex-restore:23-26 and
# agentic-set-profile:24-27, which said the same thing in different words.
#
# Usage: assert_valid_profile <value> <what>
assert_valid_profile() {
    profile_is_valid "$1" && return 0
    log_err "$2 must be 'work' or 'personal', got '$1'"
    return 1
}

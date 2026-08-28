#!/bin/bash
#
# The accept-list behind `just doctor`.
#
# bin/dotfiles-doctor had no way to record a finding as known, so every
# true-but-accepted fact was reported at the same volume as genuine news, on
# every run, forever — three of them on macbook-m5-pro that no action could
# ever clear. A health check that cannot go green stops being read, which
# costs more than the findings it was reporting (SI-126).
#
# bin/dotfiles-lint solved the same problem once already, with .lint-baseline.
# This is the doctor's equivalent, and deliberately NOT the same shape:
# .lint-baseline is a count, which works for shellcheck because any increase
# fails. Doctor's findings are qualitative and differ per machine, so a count
# would hide a new finding the moment an old one was fixed. This is an
# accept-list keyed on identity instead.
#
# ROW FORMAT — check|host|glob|reason
#
#   check   the doctor check the finding comes from (brewfile, runtimes, …)
#   host    a hostname, or "*" for every host
#   glob    matched against the finding text with shell globbing, so a finding
#           carrying a count or a path can be accepted without pinning it
#   reason  why this is accepted, and ideally the ticket. Mandatory —
#           `just lint` fails a row without one, because an accept-list whose
#           entries have no stated reason is just a way of losing information.
#
# WHY ONLY FULL-LINE COMMENTS ARE STRIPPED
#
# Unlike bin/lib/config-owners.manifest, an inline `#` is NOT a comment here. A
# reason routinely wants to name a PR or an issue — "cross-host split, see #17"
# — and stripping from the first `#` would silently truncate it, leaving a row
# whose stated reason is half a sentence. Only a line whose first non-blank
# character is `#` is a comment.
#
# Pure: every input is an argument, so `just lint unit` drives it against
# fixtures with no baseline file, no doctor and no machine state.

# Print the non-comment, non-blank rows of a baseline file.
#
# Usage: baseline_rows <file>
baseline_rows() {
    [ -f "$1" ] || return 0
    grep -v '^[[:space:]]*#' "$1" | grep -v '^[[:space:]]*$'
}

# Does a row accept this finding? Echoes "glob<TAB>reason" and returns 0 if so.
#
# The glob is returned as well as the reason because the caller has to know
# *which* row matched: a row that matches nothing has outlived its finding and
# should be deleted, and that is only detectable by recording the hits.
#
# Usage: baseline_accepts <check> <host> <message> <file>
baseline_accepts() {
    local check=$1 host=$2 msg=$3 file=$4
    local r_check r_host r_glob r_reason

    [ -f "$file" ] || return 1

    while IFS='|' read -r r_check r_host r_glob r_reason; do
        [ -n "$r_check" ] || continue
        [ "$r_check" = "$check" ] || continue
        [ "$r_host" = "*" ] || [ "$r_host" = "$host" ] || continue
        # Unquoted on purpose: this is the glob match, and quoting it here
        # would turn every row into an exact-string comparison.
        # shellcheck disable=SC2254
        case "$msg" in
            $r_glob)
                printf '%s\t%s\n' "$r_glob" "$r_reason"
                return 0
                ;;
        esac
    done <<EOF
$(baseline_rows "$file")
EOF

    return 1
}

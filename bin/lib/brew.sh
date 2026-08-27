#!/bin/bash
#
# Homebrew helpers, and the one command in this repository that can uninstall
# something you did not ask it to uninstall.
#
# DELIBERATELY NOT SOURCED BY bin/lib/common.sh.
#
# The same call common.sh:54-56 makes for shells.sh and privilege.sh: this file
# holds `brew bundle cleanup --force`, which removes every formula and cask
# absent from the named Brewfile, and that has no business in the namespace of
# every script in bin/. The callers source it explicitly:
#
#   # shellcheck source-path=SCRIPTDIR
#   # shellcheck source=lib/brew.sh
#   . "$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/brew.sh" || exit 1
#
# The split below is bin/lib/sync.sh's, for the same reason: a pure planner that
# prints and cannot delete, a separate applier that does, and exactly one
# guarded call site. `just lint unit` pins it, so a revert fails the gate.

# Print what the Brewfile names and this machine does not have.
#
# --no-upgrade is load-bearing, not tidiness. Without it `brew bundle check`
# reports every *outdated* package as "needs to be installed or updated": 40+
# lines on this machine, including mise, which is plainly installed. That is
# indistinguishable from real drift, so a check without the flag reports noise
# and gets ignored. With it, the output is what is genuinely absent.
#
# Prints; never logs — this is the pure/impure rule from bin/lib/log.sh:14-18,
# so a caller can capture it. Returns non-zero when something is missing, which
# is `brew bundle check`'s own contract.
#
# Usage: brew_missing <brewfile>
brew_missing() {
    brew bundle check --no-upgrade --verbose --file "$1"
}

# Print what a prune would remove. Cannot remove anything: `brew bundle cleanup`
# without --force only lists, which is the whole reason this is safe to run
# unprompted.
#
# The exit status answers "is there anything to prune", not "did it work":
# `brew bundle cleanup` returns 1 when it has something to list and 0 when it
# does not. So callers must test it rather than let `set -e` see it — the first
# version of the caller did not, and the prune path exited before it ever
# reached its confirmation prompt.
#
# Reading a status that way is only safe because it degrades in the right
# direction: a genuine brew error also returns non-zero, is therefore read as
# "there is work", and lands on the confirmation, where the answer is no.
#
# Usage: brew_prune_plan <brewfile>
brew_prune_plan() {
    brew bundle cleanup --file "$1"
}

# The impure half, and the only uninstall in this repository.
#
# Routed through `run` so --dry-run prints it instead. Called from exactly one
# `if` in bin/homebrew-restore, behind --prune and behind a confirmation that
# --yes cannot answer. unit_brew_no_force fails if that stops being true.
#
# Usage: brew_prune_apply <brewfile>
brew_prune_apply() {
    run brew bundle cleanup --force --file "$1"
}

# --- Brewfile analysis ------------------------------------------------------
#
# Pure: each takes file paths, prints findings on stdout, and reads nothing
# else. That is what lets `just lint unit` drive them from fixtures carrying
# each known defect, rather than from whatever this machine happens to have.
#
# They are awk rather than bash because the work is grouping by key, and bash
# 3.2 — the /bin/bash macOS ships, which runs all of this — has no associative
# arrays. Output is piped through `sort` because awk's `for (k in a)` has no
# defined order, and a check whose output reshuffles between runs is a check
# nobody can diff.
#
# All three answer questions the Brewfiles cannot answer for themselves: they
# are `brew bundle dump` output, one per host, and nothing compares them.

# Print App Store entries whose name and id do not agree, across every file
# given. Two directions, because both occur:
#
#   one name, several ids   — an app re-listed under a new App Store ID while
#                             the old entry stayed. Pages carries 361309726 and
#                             409201541 in a single file.
#   one id, several names   — the same app dumped under a different name on
#                             another host. `MindNode 2` and `MindNode` are both
#                             6446116532, which defeats any name-keyed diff.
#
# Both are machine state rather than file content, so the fix is on the host and
# a re-dump, never an edit here.
#
# Usage: brewfile_mas_conflicts <file>...
brewfile_mas_conflicts() {
    awk '
        /^mas "/ {
            name = $0; sub(/^mas "/, "", name); sub(/".*/, "", name)
            id   = $0; sub(/.*id:[ ]*/, "", id); sub(/[^0-9].*/, "", id)
            host = FILENAME; sub(/.*\//, "", host)
            if (!((name SUBSEP id) in seen)) {
                seen[name SUBSEP id] = 1
                ids[name]    = ids[name] " " id
                names[id]    = names[id] " " name
                n_ids[name]++
                n_names[id]++
            }
            where[name SUBSEP id] = where[name SUBSEP id] " " host
        }
        END {
            for (n in n_ids)
                if (n_ids[n] > 1) print "mas \"" n "\" has several ids:" ids[n]
            for (i in n_names)
                if (n_names[i] > 1) print "mas id " i " has several names:" names[i]
        }
    ' "$@" | sort
}

# Print formulae spelled bare on one host and tap-qualified on another.
#
# `brew "opencode"` and `brew "anomalyco/tap/opencode"` are the same package;
# nothing that compares the files by line can tell. Reported with the host each
# spelling came from, because the fix is to make one of them match the other and
# you need to know which machine to run it on.
#
# Usage: brewfile_tap_drift <file>...
brewfile_tap_drift() {
    awk '
        function leaf(s,   n, a) { n = split(s, a, "/"); return a[n] }
        /^brew "/ {
            name = $0; sub(/^brew "/, "", name); sub(/".*/, "", name)
            host = FILENAME; sub(/.*\//, "", host)
            l = leaf(name)
            if (!((l SUBSEP name) in seen)) {
                seen[l SUBSEP name] = 1
                spellings[l] = spellings[l] " " name "(" host ")"
                n[l]++
            }
        }
        END {
            for (l in n)
                if (n[l] > 1) print "brew \"" l "\" is spelled several ways:" spellings[l]
        }
    ' "$@" | sort
}

# Print taps pinned to a URL whose owner is not the tap's own owner.
#
# `tap "sst/tap", "https://github.com/anomalyco/homebrew-tap.git"` is a rename
# that only half happened: brew installs from anomalyco and every human reading
# the file sees sst. Left alone it silently outlives the rename it recorded.
#
# Usage: brewfile_tap_url_drift <file>...
brewfile_tap_url_drift() {
    awk '
        /^tap "[^"]*", *"http/ {
            name = $0; sub(/^tap "/, "", name); sub(/".*/, "", name)
            url  = $0; sub(/^[^,]*, *"/, "", url); sub(/".*/, "", url)
            host = FILENAME; sub(/.*\//, "", host)
            owner = name; sub(/\/.*/, "", owner)
            url_owner = url
            sub(/^https?:\/\/[^\/]*\//, "", url_owner)
            sub(/\/.*/, "", url_owner)
            # Case-insensitively: GitHub owners are, and `arthur-ficial/tap`
            # pinned to .../Arthur-Ficial/... is the same account written two
            # ways, not a rename. Reporting it would be the noise that gets a
            # check ignored.
            if (tolower(owner) != tolower(url_owner))
                print "tap \"" name "\" is served from " url_owner " (" host ")"
        }
    ' "$@" | sort -u
}

# So that `. lib/brew.sh || exit 1` means "the library failed to load", not
# "the last function definition happened to return non-zero".
true

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

# So that `. lib/brew.sh || exit 1` means "the library failed to load", not
# "the last function definition happened to return non-zero".
true

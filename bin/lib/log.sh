#!/bin/bash
#
# Terminal output helpers. Nine scripts declared their own GREEN/RED/YELLOW/NC
# in two different orderings, none of them TTY-aware, and re-typed the ✓ / ⊗
# convention about forty times inline.
#
# The colour codes are resolved once, at source time, from whether the stream is
# a terminal and whether NO_COLOR is set — the same scheme bin/dotfiles-lint
# uses at :54-63, which was the only TTY-aware one in the repository. That
# linter keeps its own copy on purpose: the lint engine may not depend on the
# code it lints, since a syntax error here would disable the only tool that
# catches it. Those are the only two copies, and docs/guardrails.md says so.
#
# The rule that keeps these safe to call anywhere: impure functions log, pure
# functions print data to stdout and never log. That is why sync_conflicts and
# brew_prefix can be captured in a command substitution without a progress line
# polluting the result. bin/lib/shells.sh already follows it —
# shells_file_desired printfs data, register_login_shell echoes status.

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    _DL_GREEN=$'\033[32m' _DL_YELLOW=$'\033[33m' _DL_BOLD=$'\033[1m' _DL_OFF=$'\033[0m'
else
    _DL_GREEN='' _DL_YELLOW='' _DL_BOLD='' _DL_OFF=''
fi

# log_err writes to stderr, so its colour is gated on stderr being a terminal.
# Sharing the stdout gate would emit escape codes into a `2>errors.log`.
if [ -t 2 ] && [ -z "${NO_COLOR:-}" ]; then
    _DL_RED=$'\033[31m' _DL_ROFF=$'\033[0m'
else
    _DL_RED='' _DL_ROFF=''
fi

# A plain line. Usage: log_info <message>
log_info() { printf '%s\n' "$*"; }

# A section header, preceded by a blank line. Replaces the `echo ""` plus
# `echo "Backing up settings..."` pair the agent scripts repeat ten times each.
# Usage: log_step <message>
log_step() { printf '\n%s%s%s\n' "$_DL_BOLD" "$*" "$_DL_OFF"; }

# A labelled value, e.g. `Profile: personal` with the value highlighted.
# Usage: log_field <label> <value>
log_field() { printf '%s: %s%s%s\n' "$1" "$_DL_YELLOW" "$2" "$_DL_OFF"; }

# An item that was handled. Uncoloured and indented, matching what the agent
# scripts already print. Usage: log_ok <message>
log_ok() { printf '  ✓ %s\n' "$*"; }

# An item that was absent, so nothing happened. Not a warning — hence the
# separate name from log_warn. Usage: log_skip <message>
log_skip() { printf '  %s⊗ %s%s\n' "$_DL_YELLOW" "$*" "$_DL_OFF"; }

# A coloured progress line with no glyph — "creating sandbox 'x'", as opposed to
# log_done's "✓ finished". The sbx-* launchers print about twenty of these, and
# prefixing them with a tick would misreport work that has not happened yet.
# Usage: log_note <message>
log_note() { printf '%s%s%s\n' "$_DL_GREEN" "$*" "$_DL_OFF"; }

# Something the user should notice but which is not a failure.
# Usage: log_warn <message>
log_warn() { printf '%s%s%s\n' "$_DL_YELLOW" "$*" "$_DL_OFF"; }

# A failure. Goes to stderr, unlike everything above.
# Usage: log_err <message>
log_err() { printf '%s%s%s\n' "$_DL_RED" "$*" "$_DL_ROFF" >&2; }

# The closing line of a successful run. Usage: log_done <message>
log_done() { printf '%s✓ %s%s\n' "$_DL_GREEN" "$*" "$_DL_OFF"; }

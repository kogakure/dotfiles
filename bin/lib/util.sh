#!/bin/bash
#
# Small helpers with no home of their own.
#
# brew_prefix_choose is split from brew_prefix for the same reason
# shells_file_desired is split from register_login_shell: the decision is pure
# and takes its inputs as arguments, so `just lint unit` can check the Intel
# answer on an Apple Silicon machine. The acceptance criterion names both
# architectures and only one of them exists here.

# True when $1 is an executable on PATH. Replaces three spellings of the same
# test across the repository: `command -v X >/dev/null 2>&1` in bin/,
# `command -v X &>/dev/null` in zshrc and setup.sh, and fish's `type -q`.
#
# Usage: have <command>
have() { command -v "$1" >/dev/null 2>&1; }

# The repository root. Replaces the `$HOME/.dotfiles` literal in the four agent
# scripts and the spelled-out tildes in update, gpg-keys-*, homebrew-restore and
# the preferences pair. Derived from bin/lib/common.sh's own location, so a
# clone at a non-standard path works and no caller depends on its cwd.
#
# Usage: dotfiles_root
dotfiles_root() { printf '%s\n' "$_DL_ROOT"; }

# The private submodule. Usage: private_root
private_root() { printf '%s\n' "$_DL_ROOT/private"; }

# This machine's short name, for the per-host Brewfile under homebrew/ and the
# backup manifests. `hostname -s` rather than bare `hostname`: the three
# Brewfiles are named mac-mini, macbook-2019 and macbook-m5-pro, and a machine
# reporting an FQDN would otherwise look for a Brewfile that does not exist.
#
# $DOTFILES_HOST overrides it. On macOS `hostname` returns the Bonjour name,
# which changes with the network — a fresh Mac reports something like Mac.local
# — and every host-keyed path in this repository then resolves to a file that
# does not exist. `sudo scutil --set HostName` is still the right permanent fix;
# this is the escape hatch for a one-off run and for the tests, which need to
# exercise the not-my-host path on a machine that is one of the hosts.
#
# Usage: host_id
host_id() { printf '%s\n' "${DOTFILES_HOST:-$(hostname -s)}"; }

# The per-host Brewfile. One spelling, shared by homebrew-backup,
# homebrew-restore and dotfiles-doctor — the pair used to disagree about how to
# build it, one with a tilde bash never expanded and one with an unquoted
# command substitution.
#
# Usage: brewfile_path
brewfile_path() { printf '%s\n' "$_DL_ROOT/homebrew/$(host_id)"; }

# Pure. Print the hostnames that have a Brewfile, one per line, from the
# directory given as $1 (default: the repository's homebrew/).
#
# Taking the directory as an argument is what makes it testable: `just lint
# unit` runs it against a fixture rather than against whatever this machine
# happens to have. Every caller wants the same thing — the list to print when a
# host does not match — and setup.sh's preflight had its own `(cd homebrew &&
# printf '%s ' *)` spelling of it.
#
# Usage: brewfile_hosts [dir]
brewfile_hosts() {
    local dir=${1:-$_DL_ROOT/homebrew} entry
    [ -d "$dir" ] || return 0
    for entry in "$dir"/*; do
        [ -f "$entry" ] || continue
        printf '%s\n' "${entry##*/}"
    done
}

# Print one entry per line from a packages/ data file, dropping `#` comments,
# trailing whitespace and blank lines.
#
# The lists these files hold — gh extensions, herdr plugins, brew services —
# were inline in setup.sh while bin/update needed the same ones, so there was no
# shared definition and they drifted: gh-stack was installed on a machine and in
# neither the script nor the docs, and one of three herdr plugins was missing.
# A file both scripts read is reviewable in a diff; two arrays in two scripts
# are not.
#
# Pure: it takes the path as an argument and prints, so `just lint unit` can
# check the parse against fixtures. Returns 1 on a missing file, so a caller can
# fail loudly rather than install nothing.
#
# Usage: package_list <file>
package_list() {
    [ -f "$1" ] || return 1
    sed -e 's/#.*//' \
        -e 's/^[[:space:]]*//' \
        -e 's/[[:space:]]*$//' \
        -e '/^$/d' "$1"
}

# Decide whether to run, given the state of the private submodule. $@ are
# submodule-relative paths this step writes ("preferences", "claude/work").
#
# Three ways this is reached, wanting three different answers:
#
#   * a nested call from bin/dotfiles-backup, which checked once already. The
#     aggregator's first step dirties private, so without this the second step
#     would refuse and the aggregator would break itself. -> return at once.
#   * a routine backup, private dirty because yesterday's backup is not
#     committed yet. Refusing protects nothing — the change is this machine's
#     own and re-running is idempotent — and it would make `just update`, which
#     is run routinely, fail on the second consecutive day. -> warn, continue.
#   * a --prune run. Pruning is the only irreversible mode: it deletes backup
#     content on the strength of "the source is not on *this* machine", and
#     private is shared with two others. -> refuse.
#
# Scoping to $@ is the other half of the ergonomics: an uncommitted change under
# claude/work no longer blocks preferences-backup.
#
# Escape hatches, both listed in every --help:
#   --allow-dirty                     downgrades the refusal to a warning
#   DOTFILES_REQUIRE_CLEAN_PRIVATE=1  upgrades the warning to a refusal, which
#                                     is SI-82's criterion read literally
#
# Usage: private_gate <path>...
private_gate() {
    local root=$_DL_ROOT/private dirty

    if [ "${DOTFILES_PRIVATE_GATE:-}" = checked ]; then
        return 0
    fi
    export DOTFILES_PRIVATE_GATE=checked

    if [ ! -e "$root/.git" ]; then
        log_warn "private is not a git checkout — skipping the cleanliness check"
        return 0
    fi
    if ! dirty=$(git -C "$root" status --porcelain -- "$@" 2>/dev/null); then
        log_warn "cannot read the private submodule status — skipping the check"
        return 0
    fi
    if [ -z "$dirty" ]; then
        return 0
    fi

    if [ "${DOTFILES_ALLOW_DIRTY:-0}" -eq 1 ]; then
        log_warn "private has uncommitted changes; continuing (--allow-dirty)"
        return 0
    fi
    if [ "${DOTFILES_PRUNE:-0}" -eq 1 ] ||
        [ "${DOTFILES_REQUIRE_CLEAN_PRIVATE:-0}" -eq 1 ]; then
        log_err "private has uncommitted changes under: $*"
        printf '%s\n' "$dirty" >&2
        log_err ""
        if [ "${DOTFILES_PRUNE:-0}" -eq 1 ]; then
            log_err "Pruning deletes backup content that may be another"
            log_err "machine's only copy, so it will not run on top of"
            log_err "uncommitted changes."
        else
            log_err "DOTFILES_REQUIRE_CLEAN_PRIVATE is set, which makes a"
            log_err "clean submodule a hard precondition."
        fi
        log_err "Commit or discard the changes first:"
        log_err "    git -C ${root} status"
        log_err "Or accept the risk with --allow-dirty."
        return 1
    fi
    log_warn "private has uncommitted changes under: $* (no --prune, continuing)"
    printf '%s\n' "$dirty" >&2
    return 0
}

# Pure. Pick a Homebrew prefix from a machine architecture and the candidate
# prefixes that actually exist.
#
# Usage: brew_prefix_choose <arch> [prefix...]
brew_prefix_choose() {
    local arch=$1 preferred candidate
    shift
    case $arch in
        arm64 | aarch64) preferred=/opt/homebrew ;;
        *) preferred=/usr/local ;;
    esac
    for candidate in "$@"; do
        if [ "$candidate" = "$preferred" ]; then
            printf '%s\n' "$preferred"
            return 0
        fi
    done
    # The architecture's own prefix is not installed. Take the first that is, so
    # an Intel Homebrew running under Rosetta on Apple Silicon still resolves.
    for candidate in "$@"; do
        printf '%s\n' "$candidate"
        return 0
    done
    # Nothing installed yet: name where it will go. setup.sh needs the prefix
    # before Homebrew exists, which is why this cannot be `brew --prefix`.
    printf '%s\n' "$preferred"
}

# The impure edge: read the architecture and the filesystem, then delegate.
# Deliberately not `brew --prefix` — hooks run these scripts through `sh -c`
# with no brew on PATH, and setup.sh needs an answer before Homebrew exists.
#
# Usage: brew_prefix
brew_prefix() {
    local found=() candidate
    for candidate in /opt/homebrew /usr/local; do
        [ -x "$candidate/bin/brew" ] && found[${#found[@]}]=$candidate
    done
    # ${a[@]+"${a[@]}"} rather than "${a[@]}": bash 3.2 treats an empty array as
    # unbound under `set -u`, and these scripts run under it.
    brew_prefix_choose "$(uname -m)" ${found[@]+"${found[@]}"}
}

# Ask a yes/no question; non-zero means no. Absorbs the copy at
# preferences-restore:35-44 and the four `read -p ... -n 1 -r` sites in the
# agent scripts, standardising on the full-line form (Enter required) rather
# than the single-keypress one — it is the more careful of the two, and the more
# recently written.
#
# Deliberately does NOT consult DOTFILES_ASSUME_YES. The prompts behind this are
# an `rm -rf` and a Dock wipe, so a helper that could be auto-confirmed from the
# environment is the wrong shape. A script with a --yes flag guards the call
# site instead, where the reader can see it:
#
#   if [ "$DOTFILES_ASSUME_YES" -eq 1 ] || confirm "Wipe the Dock?"; then
#
# With no terminal at all the answer is no, which is what an unattended run
# should get for something irreversible. This is also the fix for a latent bug:
# under `set -e`, the bare `read -p` this replaces returned non-zero when stdin
# was not a tty and aborted the whole script.
#
# Usage: confirm <prompt>
confirm() {
    local prompt=$1 reply
    printf '%s [y/N] ' "$prompt"
    # Plain stdin, like the copy this replaces. Reading from /dev/tty instead
    # would look more thorough and would be a regression: it ignores piped
    # input, so `printf 'y\n' | preferences-restore` stops working, and `-r
    # /dev/tty` can test true in a context where opening it still fails.
    #
    # A failed read means EOF — no terminal and no piped answer — and the answer
    # is then "no", which is what an unattended run should get for something
    # irreversible. Under `set -e` this is also the fix for the bare `read -p`
    # it replaces, which aborted the whole script instead.
    if ! read -r reply; then
        printf 'no (no input)\n'
        return 1
    fi
    case $reply in
        [yY] | [yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

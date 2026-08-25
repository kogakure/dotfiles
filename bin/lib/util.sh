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
# Usage: host_id
host_id() { hostname -s; }

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
        log_err "Pruning deletes backup content that may be another machine's"
        log_err "only copy, so it will not run on top of uncommitted changes."
        log_err "Commit or discard them first:"
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
    if [ ! -t 0 ] && [ ! -r /dev/tty ]; then
        printf '%s [y/N] no (not a terminal)\n' "$prompt"
        return 1
    fi
    printf '%s [y/N] ' "$prompt"
    if [ -t 0 ]; then
        read -r reply || return 1
    else
        read -r reply </dev/tty || return 1
    fi
    case $reply in
        [yY] | [yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

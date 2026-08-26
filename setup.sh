#!/bin/bash
#
# Bootstrap a macOS machine from this repository.
#
# A step registry rather than a straight line. Every action lives in a
# `step_<name>` function, ALL_STEPS is the ordered list, and the driver runs
# each one through run_step — so a failure is reported by name in a summary
# instead of aborting the run, and a re-run can resume instead of redoing an
# hour of `brew bundle`. See docs/commands.md.
#
# Safe to re-run: every step is either idempotent or guarded.
#
# Run it from anywhere. It cd's to its own directory, so the ./install, ./bin/*
# and ./private/* paths below resolve.

# `set -uo pipefail`, deliberately without -e.
#
# Per-step failure isolation and -e are mutually exclusive: -e aborts at the
# first failure, which is what made a partial run indistinguishable from a clean
# one — and what left `echo "Setup complete."` unreachable on any host where the
# second-to-last line failed. Every step goes through run_step instead, which
# keeps going and makes the run exit non-zero with the failing steps named.
# bin/update:13-17 documents the same trade for the same reason.
set -uo pipefail

cd "$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || {
    echo "setup: cannot cd to the repository root — aborting." >&2
    exit 1
}

# shellcheck source=bin/lib/common.sh
. bin/lib/common.sh || exit 1
# shellcheck source=bin/lib/shells.sh
. bin/lib/shells.sh || exit 1
# shellcheck source=bin/lib/privilege.sh
. bin/lib/privilege.sh || exit 1

dotfiles_flags_init

# --- the registry -----------------------------------------------------------
#
# Order matters and is the contract. Anything that blocks on a prompt belongs
# last; anything that provides a binary a later step calls belongs before it.
#
# `link` runs after `packages`, not before it. ./install execs dotbot, and
# dotbot is a brew formula — `brew "dotbot"` in all three Brewfiles — so it only
# exists once `packages` has run `brew bundle`. The old order called ./install
# nineteen lines before the mechanism that installs it, which worked on every
# machine that already had it and on no fresh one. Nothing between the two needs
# a linked config: install.conf.yaml has no `shell:` block and declares its own
# `create:` parents, and `brew bundle` reads homebrew/<host> straight from the
# repo.
#
# `packages` also supplies fish, which `shell_default` needs, for the same
# reason.

ALL_STEPS="preflight submodules directories homebrew packages link terminfo tmux_plugins extensions shell_default atuin gnupg runtimes editors projects macos services"

# Steps that are never recorded as completed, so they run on every invocation.
# A precondition check that can be resumed past is a check that passes on the
# strength of having once passed, which is the opposite of the point.
NEVER_RESUME="preflight"

# Completed steps, one name per line, so a re-run can skip them. Under
# XDG_STATE_HOME when it is set — but the fallback is what matters on a fresh
# machine, where nothing has exported it yet because ./install has not run.
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/setup-state"

# --- data -------------------------------------------------------------------
#
# Whitespace-delimited lists rather than arrays, so the step functions can
# iterate them unquoted without tripping the bash 3.2 empty-array rule. These
# move out to packages/ later in this phase.

HOMEBREW_INSTALLER=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
WEZTERM_TERMINFO=https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo

GH_EXTENSIONS="
dlvhdr/gh-dash
jrnxf/gh-eco
gennaro-tedesco/gh-f
yusukebe/gh-markdown-preview
meiji163/gh-notify
seachicken/gh-poi
gennaro-tedesco/gh-s
"

HERDR_PLUGINS="
cloudmanic/herdr-plus
tdi/herdr-worktree-setup
"

FISH_PLUGINS="
jorgebucaran/fisher
jorgebucaran/autopair.fish
jorgebucaran/replay.fish
edc/bass
jethrokuan/z
joshmedeski/fish-lf-icons
jethrokuan/fzf
"

SERVICES="
atuin
borders
"

SELECTED=""
ONLY=""
SKIP=""
FROM=""
FORCE=0
LIST=0

usage() {
    cat <<'EOF'
Usage: setup.sh [options] [step...]

Bootstrap a macOS machine. With no step names, runs every step in order.

Options:
  --dry-run              Print every mutation instead of applying it.
                         Never prompts for a password and never writes state.
  --only a,b             Run only these steps.
  --skip a,b             Run everything except these steps.
  --from STEP            Run STEP and everything after it.
  --force                Ignore the state file; redo completed steps.
  --list                 Print the ordered step list and exit.
  -y, --yes              Answer prompts with yes.
  -h, --help             This.

State file: ${XDG_STATE_HOME:-~/.local/state}/dotfiles/setup-state

Selection is applied in one order, whatever order the flags are given in:
--only (or every step) sets the base, --from trims the front, --skip removes.
EOF
}

# --- list helpers -----------------------------------------------------------
#
# Lists are space-delimited strings, not arrays: bash 3.2 has no associative
# arrays and treats an empty array as unbound under `set -u`. None of these use
# `case`, because bash 3.2 cannot parse `case` inside a command substitution.

# Is $1 a registered step?
step_exists() {
    local s
    for s in $ALL_STEPS; do
        [ "$s" = "$1" ] && return 0
    done
    return 1
}

# Print the elements of $1 that also appear in $2, in $1's order.
list_keep() {
    local out="" a b hit
    for a in $1; do
        hit=0
        for b in $2; do
            [ "$a" = "$b" ] && hit=1
        done
        [ "$hit" -eq 1 ] && out="$out $a"
    done
    printf '%s' "${out# }"
}

# Print the elements of $1 that do not appear in $2, in $1's order.
list_drop() {
    local out="" a b hit
    for a in $1; do
        hit=0
        for b in $2; do
            [ "$a" = "$b" ] && hit=1
        done
        [ "$hit" -eq 0 ] && out="$out $a"
    done
    printf '%s' "${out# }"
}

# Print $1 from the element $2 onward.
list_from() {
    local out="" a hit=0
    for a in $1; do
        [ "$a" = "$2" ] && hit=1
        [ "$hit" -eq 1 ] && out="$out $a"
    done
    printf '%s' "${out# }"
}

# Is $1 in the selection?
wanted() {
    local s
    for s in $SELECTED; do
        [ "$s" = "$1" ] && return 0
    done
    return 1
}

# --- state ------------------------------------------------------------------

# Has $1 already completed on an earlier run?
state_done() {
    [ -f "$STATE_FILE" ] || return 1
    grep -qxF -- "$1" "$STATE_FILE"
}

# Record $1 as completed. Inert under --dry-run: a dry run that leaves a state
# file behind has changed something, which is the one thing it promises not to.
state_record() {
    [ "$DOTFILES_DRY_RUN" -eq 1 ] && return 0
    mkdir -p "${STATE_FILE%/*}" || return 1
    state_done "$1" || printf '%s\n' "$1" >>"$STATE_FILE"
}

# --- privilege --------------------------------------------------------------

# Called at the top of every step that escalates, rather than once at the top of
# the script. Priming is itself a prompt, so priming before the arguments are
# parsed is what made `--dry-run` ask for a password before deciding to change
# nothing. Both halves are idempotent and both are inert under --dry-run.
need_privilege() {
    privilege_prime || return 1
    privilege_keepalive
}

# --- teardown ---------------------------------------------------------------

CAFFEINATE_PID=""

cleanup() {
    [ -n "$CAFFEINATE_PID" ] && kill "$CAFFEINATE_PID" 2>/dev/null
    privilege_release
    # Never let teardown decide the script's exit status.
    return 0
}
trap cleanup EXIT

# --- steps ------------------------------------------------------------------

# README.md documents nine manual prerequisites. The old script re-checked two
# of them — brew and fish — and trusted the rest, so a missing one surfaced
# later as a confusing failure somewhere else: an unreachable SSH agent made the
# submodule clone fail, and then four steps that read private/ failed for
# reasons that looked unrelated.
#
# Every check here is read-only, so the step behaves identically under
# --dry-run. Hard failures stop the run; soft ones warn and continue, because
# they are either repaired by a later step or only matter for part of the
# machine.
step_preflight() {
    local rc=0 licence root brewfiles

    # Xcode command-line tools: git, curl and tic all come from here.
    if xcode-select -p >/dev/null 2>&1; then
        log_ok "Xcode command-line tools: $(xcode-select -p)"
    else
        log_err "Xcode command-line tools are missing — run: xcode-select --install"
        rc=1
    fi

    # An unaccepted licence makes every CLT tool refuse to run, and says so on
    # stderr while exiting non-zero. That message is the only reliable signal:
    # `xcodebuild -checkFirstLaunchStatus` needs full Xcode, which is not
    # installed on any of these machines.
    licence=$(/usr/bin/git --version 2>&1 >/dev/null)
    case "$licence" in
        *[Ll]icen[cs]e*)
            log_err "the Xcode licence is not accepted — run: sudo xcodebuild -license accept"
            rc=1
            ;;
        *) log_ok "Xcode licence accepted" ;;
    esac

    # Rosetta, on Apple Silicon only. A warning rather than a failure: it is
    # needed by some casks and by nothing in this repository.
    if [ "$(uname -m)" = arm64 ]; then
        if arch -x86_64 /usr/bin/true >/dev/null 2>&1; then
            log_ok "Rosetta is available (arm64)"
        else
            log_warn "Rosetta is not installed — run: softwareupdate --install-rosetta"
        fi
    else
        log_ok "architecture: $(uname -m)"
    fi

    # The load-bearing one. A fresh Mac reports something like Mac.local, and
    # bin/homebrew-restore:41-44 then aborts the entire package install over it.
    # Fail here, where the message can name the fix, rather than there.
    brewfiles=$(cd homebrew 2>/dev/null && printf '%s ' *)
    if [ -f "homebrew/$(host_id)" ]; then
        log_ok "hostname '$(host_id)' has a Brewfile"
    else
        log_err "hostname '$(host_id)' has no Brewfile in homebrew/"
        log_err "  available: ${brewfiles% }"
        log_err "  fix with: sudo scutil --set HostName <one of those>"
        rc=1
    fi

    # dotbot: installed by the `packages` step, so its absence now is expected
    # on a fresh machine and only worth a note.
    if have dotbot; then
        log_ok "dotbot is on PATH"
    else
        log_skip "dotbot is not on PATH yet — the packages step installs it"
    fi

    # The SSH agent, via Secretive. Hard only when private/ has not been cloned
    # yet, because that is the case where the clone is about to need it; on a
    # re-run the submodule is already there and ssh is not on the critical path.
    if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "$SSH_AUTH_SOCK" ] && ssh-add -l >/dev/null 2>&1; then
        log_ok "SSH agent reachable with at least one identity"
    elif [ -e private/.git ]; then
        log_warn "SSH agent is not reachable, but private/ is already cloned"
    else
        log_err "SSH agent is not reachable and private/ is not cloned yet."
        log_err "  Start Secretive, add the key to GitHub, then export:"
        log_err "  SSH_AUTH_SOCK=\$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
        rc=1
    fi

    # Homebrew: installed by the `homebrew` step, so absence is expected here.
    if have brew; then
        log_ok "Homebrew at $(brew_prefix)"
    else
        log_skip "Homebrew is not installed yet — the homebrew step installs it"
    fi

    # Repo location. setup.sh itself has no hardcoded path — it derives the root
    # from its own location — but install.conf.yaml links ~/.agents and friends
    # and README tells you to clone to ~/.dotfiles, so a different path is worth
    # saying out loud.
    root=$(dotfiles_root)
    if [ "$root" = "$HOME/.dotfiles" ]; then
        log_ok "repository at $root"
    else
        log_warn "repository is at $root, not $HOME/.dotfiles"
    fi

    # No CLI can answer this one: `mas account` was removed from mas, and
    # nothing replaced it. Saying so is better than a check that always passes.
    log_skip "Apple ID sign-in cannot be verified from the CLI; mas entries fail without it"

    return "$rc"
}

step_submodules() {
    run git submodule update --init --recursive
}

step_directories() {
    # The dotbot links need these parents to exist.
    run mkdir -p "$HOME/.config"
    run mkdir -p "$HOME/.gnupg"
}

step_link() {
    # dotbot has its own dry run (-n), and it reports far more than `run`
    # printing the word "./install" would. It is silent when every link is
    # already in place, so name the command as well — a blank step reads like a
    # step that did nothing. `just check-links` is the same thing with -v.
    if [ "$DOTFILES_DRY_RUN" -eq 1 ]; then
        log_info "  ./install --dry-run"
        ./install --dry-run
        return
    fi
    ./install
}

step_homebrew() {
    if have brew; then
        log_ok "Homebrew is already installed"
        return 0
    fi

    # The installer is fetched only when it is going to be run: putting the
    # command substitution inside `run` would execute the curl even under
    # --dry-run, since arguments are expanded before run() ever sees them.
    if [ "$DOTFILES_DRY_RUN" -eq 1 ]; then
        log_info "  install Homebrew from $HOMEBREW_INSTALLER"
        return 0
    fi

    need_privilege
    log_info "Homebrew not found. Installing Homebrew..."
    # NONINTERACTIVE=1 stops the installer prompting for RETURN and for its own
    # password mid-run.
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALLER")" || return 1

    # Put brew on PATH for the rest of this run.
    eval "$("$(brew_prefix)/bin/brew" shellenv)"
    log_ok "Homebrew installed"
}

step_packages() {
    # homebrew-restore sources lib/common.sh, so it honours the exported
    # DOTFILES_DRY_RUN without being told again.
    ./bin/homebrew-restore
}

step_terminfo() {
    # WezTerm is a cask on macbook-2019 only, so only that host needs the entry.
    if [ ! -d /Applications/WezTerm.app ]; then
        log_skip "WezTerm is not installed on this host"
        return 0
    fi

    if [ "$DOTFILES_DRY_RUN" -eq 1 ]; then
        log_info "  install the WezTerm terminfo entry from $WEZTERM_TERMINFO"
        return 0
    fi

    log_info "Installing the WezTerm terminfo entry"
    # -fsSL is what keeps a 404 HTML body from being piped straight into tic.
    curl -fsSL "$WEZTERM_TERMINFO" | tic -x -
}

step_tmux_plugins() {
    # Once — and only after brew, which provides tmux, and after ./install,
    # which links config/tmux. This used to run three times: twice from here
    # before tmux existed, and a third time from install.conf.yaml's `shell:`
    # block.
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        run git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || return 1
    fi

    log_info "Installing tmux plugins"
    run "$HOME/.tmux/plugins/tpm/bin/install_plugins"
}

step_extensions() {
    local extension plugin rc=0

    for extension in $GH_EXTENSIONS; do
        # Current gh exits 0 on an already-installed extension, but it has not
        # always, and a directory test costs nothing and skips the network.
        if [ -d "$HOME/.local/share/gh/extensions/${extension##*/}" ]; then
            log_skip "gh extension ${extension} is already installed"
        else
            run gh extension install "$extension" || rc=1
        fi
    done

    if have herdr; then
        for plugin in $HERDR_PLUGINS; do
            run herdr plugin install "$plugin" --yes || rc=1
        done
    else
        log_skip "herdr is not installed"
    fi

    return "$rc"
}

step_shell_default() {
    local fish_path plugin rc=0

    log_info "Configuring fish as default shell"
    if ! have fish; then
        log_info "Fish shell not found. Installing fish..."
        run brew install fish || return 1
    fi

    fish_path="$(command -v fish)"
    if [ -z "$fish_path" ]; then
        # Only reachable under --dry-run, where the install above only printed.
        log_skip "fish is not installed yet; nothing to register"
        return 0
    fi

    # fisher is a fish *function*, not an executable: the brew formula ships
    # only share/fish/vendor_functions.d/fisher.fish. Every one of these was
    # previously a bare `fisher install …` in bash, where the name does not
    # resolve at all — and they ran before the fish-install check above, so on a
    # fresh machine there was no fish either. Drive them through fish, after
    # fish is guaranteed to exist.
    log_info "Installing fish plugins"
    for plugin in $FISH_PLUGINS; do
        run fish -c "fisher install $plugin" || rc=1
    done

    need_privilege

    # Register fish as a login shell. This was two byte-identical `tee -a`
    # calls, so every run appended the path twice and /etc/shells grew forever.
    # The logic now lives in bin/lib/shells.sh so `just lint unit` can exercise
    # it against a fixture — see docs/guardrails.md.
    run register_login_shell "$fish_path" || rc=1

    log_info "Changing default shell to fish"
    # Root, not the calling user: chsh on another account needs it, and this is
    # the form the script has always used.
    run sudo chsh -s "$fish_path" "$USER" || rc=1

    return "$rc"
}

step_atuin() {
    if ! have atuin; then
        log_warn "atuin not found — expected it from the Brewfile or mise."
        return 0
    fi
    run atuin login
}

step_gnupg() {
    # gpg-agent.conf is linked from gnupg/gpg-agent.conf by ./install above.
    # This used to append the pinentry line here on *every* run, which both
    # duplicated the line and — because a real file cannot be replaced by a
    # dotbot relink — meant the repo's default-cache-ttl and max-cache-ttl never
    # applied at all.
    log_info "Restarting gpg-agent"
    run gpgconf --kill gpg-agent
    run gpg-agent --daemon
    ./bin/gpg-keys-restore
}

step_runtimes() {
    # Install the tool versions pinned in config/mise/mise.toml. mise itself is
    # declared in the Brewfile and installed by the `packages` step.
    if ! have mise; then
        log_warn "mise not found — expected it from the Brewfile. Skipping tool install."
        return 0
    fi
    log_info "Installing mise tool versions"
    run mise install
}

step_editors() {
    local rc=0

    log_info "Installing Neovim plugins"
    run nvim --headless "+Lazy! sync" +qa || rc=1

    if [ -d "$HOME/.config/emacs" ]; then
        log_skip "Doom Emacs is already installed"
    else
        run git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs" || rc=1
        run "$HOME/.config/emacs/bin/doom" install || rc=1
    fi

    return "$rc"
}

step_projects() {
    if [ ! -x ./private/bin/project-setup ]; then
        log_skip "private/bin/project-setup is not available"
        return 0
    fi
    run ./private/bin/project-setup
}

step_macos() {
    local rc=0

    # Launch agents in private/launch-agents/ are not restored automatically —
    # see docs/commands.md.
    #
    # --yes because this is an unattended bootstrap. The Dock prompt 0c89693
    # added would otherwise block ten lines from the end of a long run, and with
    # stdin closed confirm() answers "no" — which silently skips the Dock on the
    # one kind of machine that actually needs it restored. The case 0c89693 was
    # protecting against, a human re-running this on a configured machine, is
    # covered instead by prefs_reset exporting the live domain to $TMPDIR before
    # it deletes anything, and by a bare `bin/preferences-restore` still
    # prompting.
    ./bin/preferences-restore --yes || rc=1

    need_privilege

    # macos-settings runs *after* the restore, and that is deliberate. The
    # restore imports whole plists, so it sets every com.apple.dock and
    # com.apple.finder key; macos-settings then overwrites only the subset it
    # declares. Net effect: the canonical settings win where they are stated,
    # the backup wins on everything else — window positions, custom Dock items,
    # recents. Swapping the two would make the macos-settings Dock and Finder
    # blocks dead code on any machine that has a backup.
    #
    # It predates lib/common.sh and reads --dry-run from argv only, so unlike
    # every other sub-script here it has to be told rather than inheriting.
    if [ "$DOTFILES_DRY_RUN" -eq 1 ]; then
        ./bin/macos-settings --dry-run || rc=1
    else
        ./bin/macos-settings || rc=1
    fi

    return "$rc"
}

step_services() {
    local service rc=0
    for service in $SERVICES; do
        run brew services start "$service" || rc=1
    done
    return "$rc"
}

# --- driver -----------------------------------------------------------------

# Steps the state file said were already done. Counted so the summary can say
# so: a run that skipped everything otherwise prints an empty OK list under
# "Setup complete.", which reads like a run that silently did nothing.
RESUMED=0

# Run one step, unless the state file says it already finished. run_step keeps
# going on failure and records the name; the state file only grows on success,
# so a resumed run retries exactly what failed.
setup_step() {
    local name=$1 failed_before resumable=1

    for skip in $NEVER_RESUME; do
        [ "$skip" = "$name" ] && resumable=0
    done

    if [ "$resumable" -eq 1 ] && [ "$FORCE" -eq 0 ] && state_done "$name"; then
        log_step "$name"
        log_skip "already completed on an earlier run (--force to redo)"
        RESUMED=$((RESUMED + 1))
        return 0
    fi

    failed_before=${#_DL_STEP_FAILED[@]}
    run_step "$name" "step_$name"
    if [ "${#_DL_STEP_FAILED[@]}" -eq "$failed_before" ] && [ "$resumable" -eq 1 ]; then
        state_record "$name"
    fi
    return 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) DOTFILES_DRY_RUN=1 ;;
        -y | --yes) DOTFILES_ASSUME_YES=1 ;;
        --force) FORCE=1 ;;
        --list) LIST=1 ;;
        --only)
            shift
            ONLY="${1:-}"
            ;;
        --only=*) ONLY="${1#*=}" ;;
        --skip)
            shift
            SKIP="${1:-}"
            ;;
        --skip=*) SKIP="${1#*=}" ;;
        --from)
            shift
            FROM="${1:-}"
            ;;
        --from=*) FROM="${1#*=}" ;;
        -h | --help)
            usage
            exit 0
            ;;
        -*)
            log_err "setup: unknown option: $1"
            usage
            exit 1
            ;;
        *) ONLY="${ONLY:+$ONLY,}$1" ;;
    esac
    shift
done

if [ "$LIST" -eq 1 ]; then
    for step in $ALL_STEPS; do
        printf '%s\n' "$step"
    done
    exit 0
fi

# Commas so `--only a,b` reads naturally; the list helpers want whitespace.
ONLY=$(printf '%s' "$ONLY" | tr ',' ' ')
SKIP=$(printf '%s' "$SKIP" | tr ',' ' ')

for step in $ONLY $SKIP $FROM; do
    step_exists "$step" || {
        log_err "setup: unknown step: $step"
        log_info "Known steps: $ALL_STEPS"
        exit 1
    }
done

if [ -n "$ONLY" ]; then
    SELECTED=$(list_keep "$ALL_STEPS" "$ONLY")
else
    SELECTED=$ALL_STEPS
fi
[ -n "$FROM" ] && SELECTED=$(list_from "$SELECTED" "$FROM")
[ -n "$SKIP" ] && SELECTED=$(list_drop "$SELECTED" "$SKIP")

if [ -z "$SELECTED" ]; then
    log_err "setup: the selection is empty"
    exit 1
fi

# Sub-scripts read these from the environment rather than argv, because
# assembling a possibly-empty flag array is fatal under bash 3.2 + `set -u`.
export DOTFILES_DRY_RUN DOTFILES_ASSUME_YES DOTFILES_ALLOW_DIRTY DOTFILES_PRUNE

log_step "setup"
log_field "steps" "$SELECTED"
[ "$DOTFILES_DRY_RUN" -eq 1 ] && log_warn "dry run: nothing will be changed"

# Sleep prevention. Not a step: it is infrastructure for the ones that follow,
# and the trap above is what stops it.
if [ "$DOTFILES_DRY_RUN" -eq 0 ]; then
    caffeinate -d -i -m -s &
    CAFFEINATE_PID=$!
    log_ok "sleep prevention active"
fi

for step in $ALL_STEPS; do
    wanted "$step" || continue
    setup_step "$step"

    # preflight is a precondition, not a peer of the steps after it. When the
    # machine is not ready they fail for reasons that look unrelated to the
    # cause — a hostname with no Brewfile aborts `brew bundle` and takes every
    # package with it, and then nine steps fail because their binaries are
    # missing. Stop at the cause instead of reporting sixteen consequences.
    if [ "$step" = preflight ] && [ ${#_DL_STEP_FAILED[@]} -gt 0 ]; then
        log_err "preflight failed — fix the above and re-run, or --skip preflight."
        break
    fi
done

summary_rc=0
step_summary || summary_rc=1
[ "$RESUMED" -gt 0 ] && log_skip "$RESUMED step(s) already done on an earlier run"
[ "$summary_rc" -eq 0 ] || exit 1
log_done "Setup complete."

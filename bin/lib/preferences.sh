#!/bin/bash
#
# Manifest-driven application preferences, shared by bin/preferences-backup and
# bin/preferences-restore.
#
# The two scripts were literal mirror images: twelve app blocks where the only
# difference was the direction of the cp arguments and export/import, with
# ~/.dotfiles/private/preferences hardcoded seventeen times in one of them and
# every single operation unguarded. The table now lives in
# bin/lib/preferences.manifest and the direction lives in the two entry points.
#
# The parsing here is more careful than it looks, for two reasons:
#
#   * Rows are loaded into memory, not streamed through the consuming loop. The
#     Dock entry calls `read` for its confirmation, and a `while read < manifest`
#     loop would hand that prompt the *next manifest line* as the user's answer.
#     Holding the rows is also what lets the restore make three passes.
#   * Fields are split with parameter expansion, not `IFS='|' read`. The latter
#     needs either a here-string (a temp file, which --dry-run must not create)
#     or a pipeline (a subshell, which cannot set the caller's variables).
#     Parameter expansion never word-splits, so "Application Support" is safe by
#     construction rather than by quoting discipline.

PREFS_ROWS=()
PREFS_KIND=""
PREFS_LABEL=""
PREFS_LIVE=""
PREFS_BACKUP=""
PREFS_OPTIONS=""

# Number of "|"-separated fields in $1. Pure string work: no awk, no subshell,
# and no assumption about IFS at the call site.
#
# Usage: prefs_field_count <row>
prefs_field_count() {
    local rest=$1 n=1
    while [ "${rest#*|}" != "$rest" ]; do
        rest=${rest#*|}
        n=$((n + 1))
    done
    printf '%s' "$n"
}

# Split a row into PREFS_KIND / _LABEL / _LIVE / _BACKUP / _OPTIONS.
# Usage: prefs_split <row>
prefs_split() {
    local rest=$1
    PREFS_KIND=${rest%%|*}
    rest=${rest#*|}
    PREFS_LABEL=${rest%%|*}
    rest=${rest#*|}
    PREFS_LIVE=${rest%%|*}
    rest=${rest#*|}
    PREFS_BACKUP=${rest%%|*}
    PREFS_OPTIONS=${rest#*|}
}

# Print the value of option $1 from the comma-separated option field $2. A bare
# flag token prints itself, so "non-empty" means "present".
#
# Usage: prefs_option <name> <options-field>
prefs_option() {
    local want=$1 rest=$2 token
    [ "$rest" = "-" ] && return 0
    while [ -n "$rest" ]; do
        token=${rest%%,*}
        if [ "$token" = "$rest" ]; then
            rest=""
        else
            rest=${rest#*,}
        fi
        case "$token" in
            "$want" | "${want}="*)
                printf '%s' "${token#*=}"
                return 0
                ;;
        esac
    done
    return 0
}

# Reject a malformed row up front rather than half way through a run.
#
# Takes an already-composed "file:line" label rather than the two parts. That is
# not cosmetic: prefs_load's loop reads *from* the manifest, and passing the
# filename into a call inside that loop makes shellcheck flag SC2094
# (read-and-write in one pipeline) even though nothing here writes it.
#
# Usage: prefs_validate <where>
prefs_validate() {
    local where=$1
    case "$PREFS_KIND" in
        defaults | plist | support_dir | support_contents) ;;
        *)
            log_err "preferences: $where: unknown kind: $PREFS_KIND"
            return 1
            ;;
    esac
    if [ -z "$PREFS_LABEL" ] || [ -z "$PREFS_LIVE" ] || [ -z "$PREFS_BACKUP" ]; then
        log_err "preferences: $where: label, live and backup are all required"
        return 1
    fi
    # A trailing slash in the data is the a1c332c bug waiting to happen again.
    case "$PREFS_LIVE" in
        */)
            log_err "preferences: $where: live must not end in \"/\""
            return 1
            ;;
    esac
    case "$PREFS_BACKUP" in
        */)
            log_err "preferences: $where: backup must not end in \"/\""
            return 1
            ;;
    esac
    # cp -R copies *into* an existing destination directory, so support_dir has
    # to be copied to its parent — unambiguous only while the backup name is a
    # bare name at the top of private/preferences/.
    if [ "$PREFS_KIND" = support_dir ]; then
        case "$PREFS_BACKUP" in
            */*)
                log_err "preferences: $where: a support_dir backup name cannot contain \"/\""
                return 1
                ;;
        esac
    fi
    return 0
}

# Load $1 into PREFS_ROWS, one raw line per element.
# Usage: prefs_load <manifest>
prefs_load() {
    local file=$1 line n=0 count
    PREFS_ROWS=()
    if [ ! -f "$file" ]; then
        log_err "preferences: manifest not found: $file"
        return 1
    fi
    # `|| [ -n "$line" ]` keeps a final line with no trailing newline.
    while IFS= read -r line || [ -n "$line" ]; do
        n=$((n + 1))
        case "$line" in
            '' | '#'*) continue ;;
        esac
        count=$(prefs_field_count "$line")
        if [ "$count" -ne 5 ]; then
            log_err "preferences: $file:$n: want 5 fields, got $count"
            return 1
        fi
        prefs_split "$line"
        prefs_validate "$file:$n" || return 1
        PREFS_ROWS[${#PREFS_ROWS[@]}]=$line
    done <"$file"
    if [ ${#PREFS_ROWS[@]} -eq 0 ]; then
        log_err "preferences: $file has no entries"
        return 1
    fi
    return 0
}

# The manifest's own location, next to this file.
# Usage: prefs_manifest
prefs_manifest() { printf '%s\n' "$_DL_LIB/preferences.manifest"; }

# Where the backups live. Usage: prefs_dir
prefs_dir() { printf '%s\n' "$_DL_ROOT/private/preferences"; }

# --- backup -----------------------------------------------------------------

# Back up the row currently split into PREFS_*. <prefs> is the backup directory.
# Usage: prefs_backup <prefs-dir>
prefs_backup() {
    local prefs=$1 dest="$1/$PREFS_BACKUP" live="$HOME/$PREFS_LIVE"

    case "$PREFS_KIND" in
        defaults)
            # `defaults export` on a domain that does not exist exits 0 and
            # writes an empty <dict/>. Without this guard, running the backup on
            # a machine that lacks the app silently replaces a good plist with
            # an empty one — and the next `defaults import` would then wipe a
            # working domain. This is the real content of "does not abort on an
            # app that was never installed": the risk was corruption, not the
            # exit status.
            if ! defaults read "$PREFS_LIVE" >/dev/null 2>&1; then
                log_skip "$PREFS_LABEL: domain $PREFS_LIVE does not exist here"
                return 0
            fi
            run defaults export "$PREFS_LIVE" "$dest"
            ;;
        plist)
            if [ ! -f "$live" ]; then
                log_skip "$PREFS_LABEL: $PREFS_LIVE is not on this machine"
                return 0
            fi
            run cp "$live" "$dest"
            ;;
        support_dir)
            if [ ! -e "$live" ]; then
                log_skip "$PREFS_LABEL: $PREFS_LIVE is not on this machine"
                return 0
            fi
            # Destination is the *parent*: cp -R copies into an existing
            # directory, so naming the target would nest it one level deeper on
            # every run.
            run cp -R "$live" "$prefs/"
            ;;
        support_contents)
            if [ ! -d "$live" ]; then
                log_skip "$PREFS_LABEL: $PREFS_LIVE is not on this machine"
                return 0
            fi
            # A contents-copy into a self-creating destination. The trailing
            # slashes on both sides are what make the pair round-trip.
            run mkdir -p "$dest"
            run cp -R "$live/" "$dest/"
            ;;
    esac
    [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] || log_ok "$PREFS_LABEL"
    return 0
}

# --- restore ----------------------------------------------------------------

# Guard a support-directory restore: the backup has to hold it, and the
# destination has to exist already. Creating the destination ourselves would
# leave a half-configured app. Non-zero means the caller should skip.
#
# Usage: prefs_dest_ready <source> <destination>
prefs_dest_ready() {
    local source=$1 destination=$2
    if [ ! -e "$source" ]; then
        log_skip "$(basename "$source") is not in the backup"
        return 1
    fi
    if [ ! -d "$destination" ]; then
        log_skip "$destination does not exist — launch the app once first."
        return 1
    fi
    return 0
}

# Confirm, snapshot, then clear the ":"-separated keys in $1 from the current
# row's domain. Returns 1 when the user declines, and the caller then skips the
# import as well — `defaults import` replaces the domain, so importing at all is
# the destructive act. Gating only the deletes would undo 0c89693.
#
# Usage: prefs_reset <keys>
prefs_reset() {
    local keys=$1 key saved
    if [ "${DOTFILES_ASSUME_YES:-0}" -eq 0 ] &&
        ! confirm "Remove the current ${PREFS_LABEL} contents and import the backup?"; then
        return 1
    fi
    # An unattended --yes should still be undoable. These three lines are what
    # make setup.sh passing --yes defensible.
    saved="${TMPDIR:-/tmp}/${PREFS_LIVE}.before-restore.plist"
    if defaults read "$PREFS_LIVE" >/dev/null 2>&1; then
        run defaults export "$PREFS_LIVE" "$saved"
        log_info "  previous $PREFS_LABEL saved to $saved"
    fi
    while [ -n "$keys" ]; do
        key=${keys%%:*}
        if [ "$key" = "$keys" ]; then
            keys=""
        else
            keys=${keys#*:}
        fi
        # `|| true`: the key may legitimately not be set yet.
        run defaults delete "$PREFS_LIVE" "$key" 2>/dev/null || true
    done
    return 0
}

# Restore the row currently split into PREFS_*. <prefs> is the backup directory.
# Usage: prefs_restore <prefs-dir>
prefs_restore() {
    local prefs=$1 source="$1/$PREFS_BACKUP" live="$HOME/$PREFS_LIVE"
    local reset restart

    case "$PREFS_KIND" in
        defaults)
            if [ ! -f "$source" ]; then
                log_skip "$PREFS_BACKUP is not in the backup"
                return 0
            fi
            reset=$(prefs_option reset "$PREFS_OPTIONS")
            if [ -n "$reset" ]; then
                if ! prefs_reset "$reset"; then
                    log_info "Leaving the ${PREFS_LABEL} alone."
                    return 0
                fi
                run defaults import "$PREFS_LIVE" "$source"
                log_info "${PREFS_LABEL} restored. Please log out and back in to apply the changes."
                return 0
            fi
            run defaults import "$PREFS_LIVE" "$source"
            restart=$(prefs_option restart "$PREFS_OPTIONS")
            if [ -n "$restart" ]; then
                run killall "$restart" 2>/dev/null || true
            fi
            ;;
        plist)
            if [ ! -f "$source" ]; then
                log_skip "$PREFS_BACKUP is not in the backup"
                return 0
            fi
            run cp "$source" "$HOME/${PREFS_LIVE%/*}/"
            ;;
        support_dir)
            # ${PREFS_LIVE%/*} is the parent, i.e. the old BARTENDER_DEST.
            prefs_dest_ready "$source" "$HOME/${PREFS_LIVE%/*}" || return 0
            run cp -R "$source" "$HOME/${PREFS_LIVE%/*}/"
            ;;
        support_contents)
            if [ ! -d "$source" ]; then
                log_skip "$PREFS_BACKUP is not in the backup"
                return 0
            fi
            run cp -R "$source/" "$live/"
            ;;
    esac
    [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] || log_ok "$PREFS_LABEL"
    return 0
}

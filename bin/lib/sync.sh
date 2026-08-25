#!/bin/bash
#
# The copy helpers the four agent backup/restore scripts held ten copies of.
#
# NONE OF THESE DELETE ANYTHING.
#
# codex-backup's backup_file and backup_dir used to `rm -f "$dest"` /
# `rm -rf "$dest"` when the source was absent; claude-backup's did not. Nobody
# chose that divergence, and adopting the pruning version as the shared default
# would, on any one machine, delete from private/<agent>/<profile>/ everything
# committed from another host and absent here — that directory is not
# host-namespaced. It is not hypothetical: private/codex/{personal,work} were
# last written from mac-mini.
#
# So the unification goes the safe way, and pruning becomes an explicit second
# pass driven by a keep-list rather than by each source's absence. The
# acceptance criterion asks for exactly that — "--prune removes only entries
# absent from the manifest" — which a per-call `rm` cannot express: "this one
# source is missing" is a different predicate from "absent from the manifest".
# `just lint unit` pins the no-delete property, so a revert fails the gate.
#
# The cost, until --prune is wired: deleting a file from ~/.codex no longer
# removes it from the backup. `rsync -a --delete` below still mirrors *within*
# an existing source directory, so only whole-entry disappearance is affected.

# Usage: sync_file_count <dir>
sync_file_count() { find "$1" -type f | wc -l | tr -d ' '; }

# Copy one file if it exists. Usage: backup_file <src> <dest>
backup_file() {
    local src=$1 dest=$2
    if [ -f "$src" ]; then
        run mkdir -p "$(dirname "$dest")"
        run cp "$src" "$dest"
        [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] || log_ok "Backed up: $(basename "$src")"
    else
        log_skip "Not found: $(basename "$src")"
    fi
}

# Mirror one non-empty directory.
#
# `mkdir -p "$dest"` rather than claude's `mkdir -p "$(dirname "$dest")"`. Both
# work, since rsync creates the final component when the parent exists, but this
# is what both restore_dir copies already did — so backup_dir and restore_dir
# now have the same shape, which is the whole reason they share a file.
#
# Usage: backup_dir <src> <dest>
backup_dir() {
    local src=$1 dest=$2
    if [ -d "$src" ] && [ -n "$(ls -A "$src" 2>/dev/null)" ]; then
        run mkdir -p "$dest"
        run rsync -a --delete "$src/" "$dest/"
        [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] ||
            log_ok "Backed up: $(basename "$src")/ ($(sync_file_count "$src") files)"
    else
        log_skip "Not found or empty: $(basename "$src")/"
    fi
}

# Usage: restore_file <src> <dest>
restore_file() {
    local src=$1 dest=$2
    if [ -f "$src" ]; then
        run mkdir -p "$(dirname "$dest")"
        run cp "$src" "$dest"
        [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] || log_ok "Restored: $(basename "$dest")"
    else
        log_skip "Not in backup: $(basename "$dest")"
    fi
}

# No --delete, unlike backup_dir: a restore is additive. Wiping a live ~/.claude
# subtree that the backup happens not to cover is not something a restore should
# do, and both original copies agreed on that.
#
# Usage: restore_dir <src> <dest>
restore_dir() {
    local src=$1 dest=$2
    if [ -d "$src" ] && [ -n "$(ls -A "$src" 2>/dev/null)" ]; then
        run mkdir -p "$dest"
        run rsync -a "$src/" "$dest/"
        [ "${DOTFILES_DRY_RUN:-0}" -eq 1 ] ||
            log_ok "Restored: $(basename "$dest")/ ($(sync_file_count "$src") files)"
    else
        log_skip "Not in backup: $(basename "$dest")/"
    fi
}

# Pure. Print the destinations a restore would overwrite, given <src> <dest>
# pairs.
#
# Replaces check_conflict_file, which incremented a counter and appended to an
# array that the *caller* had to declare — the coupling this file exists to
# remove, and one that also forced a "${conflict_samples[@]}" expansion that
# `set -u` rejects on bash 3.2 when the array is empty. Printing on stdout lets
# the caller count with `wc -l` and cap the sample list with `head -5`, which is
# where a presentation decision belongs.
#
# Caveat: a destination path containing a newline would be miscounted. Every
# path fed to this is a fixed config filename.
#
# Usage: sync_conflicts <src> <dest> [<src> <dest>...]
sync_conflicts() {
    local src dest
    while [ $# -ge 2 ]; do
        src=$1 dest=$2
        shift 2
        if [ -f "$src" ] && [ -f "$dest" ]; then
            printf '%s\n' "$dest"
        fi
    done
}

# Pure. Print the top-level entries of <root> whose basename is absent from the
# newline-separated <keep-file>. Prints; deletes nothing. That split is what
# makes --dry-run free and what makes this testable at all.
#
# Usage: sync_prune_extra <root> <keep-file>
sync_prune_extra() {
    local root=$1 keep=$2 entry name
    [ -d "$root" ] || return 0
    for entry in "$root"/*; do
        [ -e "$entry" ] || continue
        name=${entry##*/}
        grep -qxF -- "$name" "$keep" && continue
        printf '%s\n' "$entry"
    done
}

# The impure half: delete one entry sync_prune_extra named. The only function in
# bin/lib/ that removes anything, and it is called from exactly one guarded `if`
# per script — behind --prune, behind private_gate.
#
# Usage: sync_prune_apply <path>
sync_prune_apply() {
    local target=$1
    if [ -d "$target" ]; then
        run rm -rf "$target"
    else
        run rm -f "$target"
    fi
}

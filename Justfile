# Single entry point for this dotfiles repository.
#
#   just              list the recipes
#   just lint         run every guardrail check
#
# Recipes wrap the existing scripts, they never reimplement them. `just`
# chdirs into this file's directory before running a recipe, so every recipe
# works from any cwd — including `just -f ~/.dotfiles/Justfile <recipe>`
# invoked from $HOME.

set shell := ["bash", "-uo", "pipefail", "-c"]

# List the available recipes.
default:
    @just --list --unsorted

# Full system setup (installs everything).
setup *ARGS:
    ./setup.sh {{ ARGS }}

# Show what `just setup` would do, without touching anything.
setup-dry:
    ./setup.sh --dry-run

# Print setup.sh's ordered step list.
setup-steps:
    ./setup.sh --list

# Re-run dotbot to create/update the symlinks.
link:
    ./install

# Show what `just link` would do, without touching anything.
check-links:
    ./install --dry-run

# Update packages, plugins and backups.
update:
    bin/update

# shellcheck + shfmt + fish/zsh syntax + POSIX source test + yaml + drift.
lint *ARGS:
    bin/dotfiles-lint {{ ARGS }}

# Same checks, restricted to the files staged for commit.
lint-staged:
    bin/dotfiles-lint --staged

# Fail on a missing linter instead of skipping it. Used by CI.
lint-strict:
    bin/dotfiles-lint --strict

# Re-snapshot .lint-baseline from the current shellcheck findings.
lint-snapshot:
    bin/dotfiles-lint --snapshot shellcheck

# Regenerate the shell config from shell/*.spec (`just lint drift` gates it).
generate *ARGS:
    bin/generate-shell-config {{ ARGS }}

# Reformat every shell source in place (shfmt -i 4 -ci).
fmt:
    #!/usr/bin/env bash
    set -uo pipefail
    if ! command -v shfmt >/dev/null 2>&1; then
        echo "just fmt: shfmt not found. Install it with: mise install shfmt" >&2
        exit 1
    fi
    # Reuse dotfiles-lint's file discovery so `just fmt` and `just lint` can
    # never disagree about which files are shell sources.
    bin/dotfiles-lint --list-shell-sources | xargs shfmt -w -i 4 -ci
    echo "Formatted. Review with: git diff"

# Point core.hooksPath at .githooks so the pre-commit hook runs.
install-hooks:
    #!/usr/bin/env bash
    set -uo pipefail
    git config core.hooksPath .githooks
    echo "core.hooksPath -> $(git config core.hooksPath)"
    echo
    echo "Escape hatches:"
    echo "  git commit --no-verify        skip the hook for one commit"
    echo "  just uninstall-hooks         disable the hook entirely"

# Stop running the repo hooks.
uninstall-hooks:
    #!/usr/bin/env bash
    set -uo pipefail
    git config --unset core.hooksPath || true
    echo "core.hooksPath unset; git is back to .git/hooks"

# Health check for this machine (arrives with SI-85, Phase 6).
doctor:
    #!/usr/bin/env bash
    set -uo pipefail
    if [ -x bin/dotfiles-doctor ]; then
        exec bin/dotfiles-doctor
    fi
    echo "just doctor: bin/dotfiles-doctor does not exist yet (SI-85, Phase 6)." >&2
    exit 1

# Take every backup: claude, codex, homebrew, preferences, launch agents.
# Pass flags or step names through, e.g. `just backup --dry-run` or
# `just backup preferences`. See bin/dotfiles-backup --help.
backup *ARGS:
    bin/dotfiles-backup {{ ARGS }}

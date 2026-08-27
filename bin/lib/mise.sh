#!/bin/bash
#
# Pure readers for config/mise/mise.toml.
#
# Nothing here runs mise, installs anything or writes: these are text
# transformations over a file path, which is what makes them testable by
# `just lint unit` on a host where mise is not installed at all. The same
# pure/impure seam as bin/lib/shells.sh — bin/dotfiles-doctor asks mise the
# runtime questions, these functions only answer "what does the file declare".
#
# They exist because doctor used to parse the file with an inline
#
#   sed -n 's/^"\{0,1\}\([a-zA-Z0-9:_.-]*\)"\{0,1\}[[:space:]]*=[[:space:]]*".*/\1/p'
#
# in two places. That pattern requires the value to start with a quote, so it
# silently skipped every entry written as an inline table — which is how SI-120
# declares the four arch-split tools. Four tools dropping out of two health
# checks with no error is exactly the failure mode this repository keeps
# finding, so the parser became one tested function instead of two copies.
#
# It also only worked on [settings] by accident. `not_found_auto_install = true`
# and `idiomatic_version_file_enable_tools = [...]` have unquoted values, so the
# old pattern missed them; a parser that accepts unquoted values has to know
# about sections, and these do.

# Every tool key in the [tools] table, one per line, in file order.
#
# Handles both value forms:
#
#   fzf = "0.74.2"
#   fd  = { version = "10.4.2", os = ["macos/arm64", "linux"] }
#
# and both key forms, bare and quoted ("cargo:fd-find", "npm:pnpm").
#
# Usage: mise_tool_keys <file>
mise_tool_keys() {
    awk '
        /^[[:space:]]*\[/ { in_tools = ($0 ~ /^[[:space:]]*\[tools\]/); next }
        !in_tools { next }
        /^[[:space:]]*#/ { next }
        /=/ {
            key = $0
            sub(/=.*$/, "", key)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
            gsub(/^"|"$/, "", key)
            if (key != "") print key
        }
    ' "$1"
}

# Only the keys whose value carries an `os` filter — the host-conditional ones.
#
# mise skips an entry whose os/arch pair does not match, so a conditional key is
# expected to be inactive on some machines and its absence is not a finding.
# Doctor needs the distinction to avoid reporting the Intel half of every pair
# as broken on Apple Silicon, and vice versa.
#
# Usage: mise_tool_keys_conditional <file>
mise_tool_keys_conditional() {
    awk '
        /^[[:space:]]*\[/ { in_tools = ($0 ~ /^[[:space:]]*\[tools\]/); next }
        !in_tools { next }
        /^[[:space:]]*#/ { next }
        /=/ && /os[[:space:]]*=/ {
            key = $0
            sub(/=.*$/, "", key)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
            gsub(/^"|"$/, "", key)
            if (key != "") print key
        }
    ' "$1"
}

# The keys with any `backend:` prefix stripped, sorted and deduplicated.
#
# For comparing against another package manager's names: the backend prefix is
# mise's addressing, not the package's name. `cargo:git-delta` is Homebrew's
# `git-delta` formula and `npm:pnpm` is its `pnpm` formula, and a comparison
# against the prefixed form silently matches neither.
#
# Usage: mise_tool_binaries <file>
mise_tool_binaries() {
    mise_tool_keys "$1" | sed 's/^[a-z][a-z0-9]*://' | sort -u
}

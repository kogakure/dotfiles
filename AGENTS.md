# CLAUDE.md

This file provides guidance to agentic agents when working with code in this repository.

## Repository Overview

Personal macOS dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot). Contains configuration files for Fish shell, Neovim (LazyVim), tmux, git, and various CLI tools. Configuration files live in `config/` and are symlinked to `~/.config/` via dotbot.

## Documentation

@docs/architecture.md — Symlink management, private submodule, hostname-specific configs, file layout
@docs/commands.md — Setup, install, homebrew, update, backup/restore, and macOS settings scripts
@docs/environment.md — Fish, Neovim, tmux, version managers, git, and plugin ecosystems
@docs/git-workflow.md — Conventional commit format, types, and examples

## Notes

- **macOS-specific**: This setup is designed for macOS (uses brew, Darwin-specific paths)
- **Secrets**: Private submodule required for full functionality
- **SSH via Secretive**: SSH keys managed by Secretive.app, not filesystem files
- **GPG**: Uses pinentry-mac for password prompts
- **Fish as default**: Setup script changes login shell to fish
- **Caffeinate**: Setup script prevents sleep during installation

## Graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, invoke the `skill` tool with `skill: "graphify"` before doing anything else.

Rules:

- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, invoke the `skill` tool with `skill: "graphify"` before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

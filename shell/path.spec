# PATH, in final order, front to back. See shell/README.md for the syntax.
#
# The emitted code adds an entry only if the directory exists and is not already
# present, then appends whatever PATH it inherited. So re-running it is a no-op:
# a fish shell inside a fish shell used to carry 15 duplicated entries because
# `set -x PATH $PATH …` appends unconditionally every time.
#
# Order is load-bearing and was the single largest divergence in this repo: the
# POSIX file *prepended* /usr/bin last while fish *appended* it, so `git` was
# /usr/bin/git in bash and /opt/homebrew/bin/git in fish and zsh. Homebrew now
# wins everywhere, which is what fish and zsh already did.

# mise shims first, so a pinned toolchain beats a Homebrew or system copy.
# `mise activate` is deliberately NOT here — it is an interactive hook. The
# shims are what make node/ruby/nvim resolve in scripts, cron and `ssh host cmd`.
$HOME/.local/share/mise/shims

# This repo's own scripts.
$HOME/.dotfiles/bin
$HOME/.dotfiles/private/bin

# Homebrew.
@brew $BREW_PREFIX/bin
@brew $BREW_PREFIX/sbin
@brew $BREW_PREFIX/whalebrew/bin

# Language and agent toolchains.
$HOME/.local/pi-agent-npm/bin
$HOME/.grok/bin
$HOME/.opencode/bin
$HOME/.bun/bin
$HOME/.local/share/pnpm/bin
$HOME/.cargo/bin
$HOME/.volta/bin
$HOME/.config/emacs/bin
$HOME/.lmstudio/bin

# Locally installed binaries. config.fish also spelled this
# `$HOME/.local/share/../bin`, which is the same directory by a different name —
# so it never string-matched and was added twice.
$HOME/.local/bin

/usr/local/sbin
/usr/local/bin

# tmux plugins.
$HOME/.tmux/plugins/tmux-nvr/bin
$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin

@darwin /Applications/Obsidian.app/Contents/MacOS

# System. Listed explicitly rather than left to the inherited tail, so the
# ordering is the same whatever the parent process happened to export.
/usr/bin
/bin
/usr/sbin
/sbin

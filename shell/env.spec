# Environment variables. See shell/README.md for the syntax.
#
# Emitted to generated/session-variables.sh and config/fish/conf.d/00-env.fish.
# Anything here reaches non-interactive shells too, so it must not prompt, must
# not depend on a terminal, and must not print.

# --- General ----------------------------------------------------------------

KEYTIMEOUT = 1

# nvim is pinned in config/mise/mise.toml, so it is present on every machine.
# Both copies of this used to test `command -v zed` and then set nvim — a
# copy-paste leftover that left EDITOR unset on any host without zed.
EDITOR = nvim
GIT_EDITOR = nvim

# --- XDG base directory specification ---------------------------------------

XDG_CACHE_HOME = $HOME/.cache
XDG_CONFIG_HOME = $HOME/.config
XDG_DATA_HOME = $HOME/.local/share
XDG_STATE_HOME = $HOME/.local/state

# --- Homebrew ---------------------------------------------------------------

@darwin HOMEBREW_NO_AUTO_UPDATE = 1

# --- GPG --------------------------------------------------------------------

# Interactive only: `tty` reports "not a tty" and exits 1 without one, and a
# GPG_TTY of "not a tty" is worse than an unset one.
@interactive GPG_TTY = $(tty)

# --- jj ---------------------------------------------------------------------
#
# JJ_CONFIG_DIR is deliberately absent. config.fish:48 exported it, but jj has
# no such variable — its override is JJ_CONFIG — so it never did anything. jj
# already reads ~/.jjconfig.toml and ~/.config/jj/config.toml on its own
# (`jj config path --user` lists both), which is how the identity moved to
# private/jj/config.toml without any environment help.

# --- SSH --------------------------------------------------------------------

# macOS keys live in Secretive's secure enclave agent; Linux uses a forwarded
# SSH_AUTH_SOCK and must not be overridden.
@darwin SSH_AUTH_SOCK = $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# --- fd / fzf ---------------------------------------------------------------

%FD_OPTIONS = --follow --exclude .git --exclude node_modules
%FZF_FILES = git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l %FD_OPTIONS

FZF_ALT_C_COMMAND = fd --type d %FD_OPTIONS --color=never --hidden
FZF_ALT_C_OPTS = --preview 'tree -C {} | head -50'
FZF_CTRL_R_OPTS = --reverse
FZF_CTRL_T_COMMAND = %FZF_FILES
FZF_CTRL_T_OPTS = --preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down
FZF_DEFAULT_COMMAND = %FZF_FILES
FZF_DEFAULT_OPTS = --no-height
FZF_TMUX = 1
FZF_TMUX_OPTS = -p

# --- OpenSSL ----------------------------------------------------------------

# Unversioned `opt/openssl`, against the runtime brew prefix. The POSIX copy
# hardcoded /opt/homebrew/opt/openssl@1.1, which exists on no current machine —
# only openssl, @3, @3.6 and @4 do — so bash and zsh exported flags pointing at
# a path that was not there.
@brew LDFLAGS = -L$BREW_PREFIX/opt/openssl/lib
@brew CPPFLAGS = -I$BREW_PREFIX/opt/openssl/include
@brew PKG_CONFIG_PATH = $BREW_PREFIX/opt/openssl/lib/pkgconfig

# --- man --------------------------------------------------------------------

+MANPATH = /usr/local/man

# --- Node toolchains --------------------------------------------------------

VOLTA_HOME = $HOME/.volta
BUN_INSTALL = $HOME/.bun
PNPM_HOME = $HOME/.local/share/pnpm

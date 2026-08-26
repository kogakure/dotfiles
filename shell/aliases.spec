# Aliases. See shell/README.md for the syntax.
#
# Emitted to generated/aliases.sh and config/fish/conf.d/20-aliases.fish.
#
# Bodies are emitted single-quoted, so `$HOME` expands when the alias is *used*,
# not when it is defined. The old POSIX file used double quotes and tripped
# shellcheck SC2139 three times.
#
# `reload` is deliberately absent: it is `exec fish` in fish and
# `source ~/.bashrc` in bash, i.e. genuinely shell-specific, so it stays in each
# shell's own rc file.

# --- Folders and listings ---------------------------------------------------

... = cd ../..
.. = cd ..
cd.. = cd ..
mkdir = mkdir -p

ls = eza --git --group-directories-first --icons=always
ll = eza -l --git --group-directories-first --icons=always
lt = eza --git --group-directories-first --icons=always --tree

dotfiles = cd $HOME/.dotfiles

# These three were unconditional in the POSIX copy and Darwin-guarded in fish.
# Guarded is correct: none of the three paths exists on Linux.
@darwin icloud = cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
@darwin dropbox = cd $HOME/Dropbox

# `open -a APP FILE` takes the file *after* the flag, so no positional parameter
# is needed. The old `open $1 -a …` was a live SC2142 error — aliases cannot use
# positional parameters — and only worked because `$1` expanded to nothing.
@darwin ia = open -a "/Applications/iA Writer.app"

# --- Git --------------------------------------------------------------------

lg = lazygit

# "git local user": point this repo at the personal identity.
#
# It used to spell the name, address and signing key out inline, in two public
# files — `aliases` and config.fish — and they had to be kept in step with
# private/git/config-personal, which already held the same three values. An
# include reads them from the one place instead, so nothing can drift and no
# identity data is in this repo. It also picks up commit.gpgsign, which the
# hand-written version silently did not.
glu = git config --local include.path ~/.config/git/config-personal

# --- Editors ----------------------------------------------------------------

v = vim
@cmd:nvim vim = nvim

emacs = emacs -nw
e = emacs -nw

# --- tmux -------------------------------------------------------------------

t = tmux
ta = tmux attach

# --- Tools ------------------------------------------------------------------

ars = atuin run script
cc = claude --dangerously-skip-permissions
cx = codex --dangerously-bypass-approvals-and-sandbox
youtube-dl = yt-dlp
c = clear

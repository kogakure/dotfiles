#!/bin/bash
#
# Bootstrap a macOS machine from this repository.
#
# Safe to re-run: every step is either idempotent or guarded, which strict mode
# makes mandatory rather than merely nice — an unguarded `git clone` into an
# existing directory would abort the run on the second invocation.
#
# Run it from anywhere. Every ./install, ./bin/* and ./private/* path below is
# relative to the repo root, so the cd is not cosmetic.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" || {
    echo "setup: cannot cd to the repository root — aborting." >&2
    exit 1
}

echo "Installing dotfiles"

# *** *** sudo *** ***

# Ask once, then keep the timestamp warm. The previous version read the password
# into a shell variable and held it there for 130 lines, feeding it to sudo on
# stdin. That bought nothing: the Homebrew installer and bin/macos-settings each
# prompt again regardless, so the "ask once" design was already defeated.
sudo -v

while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

# *** *** Sleep prevention *** ***

CAFFEINATE_PID=""

cleanup() {
    [ -n "$CAFFEINATE_PID" ] && kill "$CAFFEINATE_PID" 2>/dev/null
    [ -n "${SUDO_KEEPALIVE_PID:-}" ] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
    # Never let teardown decide the script's exit status.
    return 0
}
trap cleanup EXIT

caffeinate -d -i -m -s &
CAFFEINATE_PID=$!
echo "Sleep prevention activated."

# *** *** Repository *** ***

echo "Initializing submodule(s)"
git submodule update --init --recursive

# The dotbot links below need these parents to exist.
mkdir -p ~/.config
mkdir -p ~/.gnupg

echo "Symlinking dotfiles"
./install

# *** *** Homebrew *** ***

if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    # NONINTERACTIVE=1 stops the installer prompting for RETURN and for its own
    # sudo password mid-run.
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    echo "Homebrew installed successfully."
else
    echo "Homebrew is already installed."
fi

echo "Restoring Homebrew packages..."
./bin/homebrew-restore

# *** *** Terminfo *** ***

# WezTerm is a cask on macbook-2019 only, so only that host needs the entry.
# -fsSL is what keeps a 404 HTML body from being piped straight into tic.
if [ -d /Applications/WezTerm.app ]; then
    echo "Installing the WezTerm terminfo entry"
    curl -fsSL https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo | tic -x -
fi

# *** *** tmux *** ***

# Once — and only after brew, which provides tmux, and after ./install, which
# links config/tmux. This used to run three times: twice from here before tmux
# existed, and a third time from install.conf.yaml's `shell:` block.
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

# *** *** GitHub CLI extensions *** ***

GH_EXTENSIONS=(
    dlvhdr/gh-dash
    jrnxf/gh-eco
    gennaro-tedesco/gh-f
    yusukebe/gh-markdown-preview
    meiji163/gh-notify
    seachicken/gh-poi
    gennaro-tedesco/gh-s
)

for extension in "${GH_EXTENSIONS[@]}"; do
    # Current gh exits 0 on an already-installed extension, but it has not
    # always, and a directory test costs nothing and skips the network.
    if [ -d "$HOME/.local/share/gh/extensions/${extension##*/}" ]; then
        echo "gh extension ${extension} is already installed."
    else
        gh extension install "$extension"
    fi
done

# *** *** herdr plugins *** ***

if command -v herdr >/dev/null 2>&1; then
    herdr plugin install cloudmanic/herdr-plus --yes
    herdr plugin install tdi/herdr-worktree-setup --yes
fi

# *** *** Fish *** ***

echo "Configuring fish as default shell"
if ! command -v fish &>/dev/null; then
    echo "Fish shell not found. Installing fish..."
    brew install fish
fi

FISH_PATH="$(command -v fish)"

# fisher is a fish *function*, not an executable: the brew formula ships only
# share/fish/vendor_functions.d/fisher.fish. Every one of these was previously a
# bare `fisher install …` in bash, where the name does not resolve at all — and
# they ran before the fish-install check below, so on a fresh machine there was
# no fish either. Drive them through fish, after fish is guaranteed to exist.
FISH_PLUGINS=(
    jorgebucaran/fisher
    jorgebucaran/autopair.fish
    jorgebucaran/replay.fish
    edc/bass
    jethrokuan/z
    joshmedeski/fish-lf-icons
    jethrokuan/fzf
)

echo "Installing fish plugins"
for plugin in "${FISH_PLUGINS[@]}"; do
    fish -c "fisher install $plugin"
done

# Register fish as a login shell. This was two byte-identical `tee -a` calls, so
# every run appended the path twice and /etc/shells grew forever. Collapse what
# earlier runs left behind, then append at most once.
if [ "$(grep -cxF -- "$FISH_PATH" /etc/shells || true)" -gt 1 ]; then
    echo "Collapsing duplicate ${FISH_PATH} entries in /etc/shells"
    shells_tmp="$(mktemp)"
    awk -v line="$FISH_PATH" '$0 == line && seen++ { next } { print }' /etc/shells >"$shells_tmp"
    # shellcheck disable=SC2024  # the redirect reads our own mktemp file; only
    # the write to /etc/shells needs privileges, which is exactly what tee does.
    sudo tee /etc/shells <"$shells_tmp" >/dev/null
    rm -f "$shells_tmp"
fi

if ! grep -qxF -- "$FISH_PATH" /etc/shells; then
    echo "Adding ${FISH_PATH} to /etc/shells"
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

echo "Changing default shell to fish"
sudo chsh -s "$FISH_PATH" "$USER"

# *** *** Atuin *** ***

atuin login

# *** *** GPG *** ***

echo "Configuring GPG to use pinentry-mac …"
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >>~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
gpg-agent --daemon
./bin/gpg-keys-restore

# *** *** mise *** ***

# Install the tool versions pinned in config/mise/mise.toml.
# mise itself is declared in the Brewfile and installed by homebrew-restore above.
echo "Installing mise tool versions"
if command -v mise &>/dev/null; then
    mise install
else
    echo "mise not found — expected it from the Brewfile. Skipping tool install." >&2
fi

# *** *** Neovim *** ***

echo "Installing Neovim plugins"
nvim --headless "+Lazy! sync" +qa

# *** *** Doom Emacs *** ***

if [ ! -d ~/.config/emacs ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install
else
    echo "Doom Emacs is already installed."
fi

# *** *** Projects *** ***

./private/bin/project-setup

# *** *** macOS settings and preferences *** ***

# Launch agents in private/launch-agents/ are not restored automatically —
# see docs/commands.md.
./bin/preferences-restore
./bin/macos-settings

# *** *** Services *** ***

brew services start atuin
brew services start borders

# Under `set -e` this line is only reached when every step above succeeded, so
# unlike the previous unconditional `echo "Done."` it now means something.
echo "Setup complete."

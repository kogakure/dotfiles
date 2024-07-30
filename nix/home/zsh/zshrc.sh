CASE_SENSITIVE="true"     # Case-sensitive completion
DISABLE_AUTO_TITLE="true" # Disable auto-setting terminal title
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7,bg=bold,underline"

# Aliases
alias reload="source $HOME/.zshrc"

# Bindkey
bindkey -v
bindkey -M viins '^r' fzf-history-widget # (r)everse history search
bindkey -M viins '^f' fzf-file-widget    # (f)ile / (t)
bindkey -M viins '^z' fzf-cd-widget      # (z) jump

# TMUX
if [ -n "$TMUX" ]; then
	eval "$(tmux show-environment -s NVIM_LISTEN_ADDRESS 2>/dev/null)"
else
	export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
fi

# Set ZSH_CACHE_DIR and ensure it exists
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

# Ensure gh completions are sourced if gh is installed
if command -v gh &>/dev/null; then
	eval "$(gh completion -s zsh)"
fi

# Atuin
if command -v atuin &>/dev/null; then
	eval "$(atuin init zsh)"
fi

# Search and preview GitHub pull requests
function ghpr() {
	GH_FORCE_TTY=100% gh pr list | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 3 | awk '{print $1}' | xargs gh pr checkout
}

# Delete all node_modules folders in a folder and subfolders
function deleteNodeModules() {
	find . -name "node_modules" -type d -exec rm -rf '{}' +
}

function homebrewBackup() {
	cd ~/.dotfiles/
	brew bundle dump --describe -f
}

function homebrewRestore() {
	brew bundle --file ~/.dotfiles/Brewfile
}

# Server
server() {
	browser-sync start --server --files "**"
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null >/dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
	IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
	key=$(head -1 <<<"$out")
	file=$(head -2 <<<"$out" | tail -1)
	if [ -n "$file" ]; then
		[ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
	fi
}

# fcd - cd into directory
fcd() {
	cd $(find * -type d | fzf --preview 'tree -C {} | head -50')
}

# fhcd – Jump to home directory and search for directories
fhcd() {
	cd $HOME
	cd $(find * -type d | fzf --preview 'tree -C {} | head -50')
}

# fdr - cd to selected parent directory
fdr() {
	local declare dirs=()
	get_parent_dirs() {
		if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
		if [[ "${1}" == '/' ]]; then
			for _dir in "${dirs[@]}"; do echo $_dir; done
		else
			get_parent_dirs $(dirname "$1")
		fi
	}

	local DIR=$(get_parent_dirs $(realpath "${1:-$(pwd)}") | fzf-tmux --tac)
	cd "$DIR"
}

# Find in files with ripgrep and fzf and open on that line
# -> Works together with Vim Plugin bogado/file-line
frg() {
	file=$(rg . --line-number | fzf | cut -d: -f1 -f2)
	if [ "$file" != "" ]; then
		nvim $file
	fi
}

# fkill - kill process
fkill() {
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

	if [ "x$pid" != "x" ]; then
		kill -${1:-9} $pid
	fi
}

# fco - checkout git branch/tag
fco() {
	local tags branches target
	tags=$(
		git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
	) || return
	branches=$(
		git branch --all | grep -v HEAD |
			sed "s/.* //" | sed "s#remotes/[^/]*/##" |
			sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
	) || return
	target=$(
		(
			echo "$tags"
			echo "$branches"
		) |
			fzf-tmux -- --no-hscroll --ansi +m -d "\t" -n 2
	) || return
	git checkout $(echo "$target" | awk '{print $2}')
}

# fcoc - checkout git commit
fcoc() {
	local commits commit
	commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
		commit=$(echo "$commits" | fzf --tac +s +m -e) &&
		git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow - git commit browser
fshow() {
	git log --graph --color=always \
		--format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
		fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
			--bind "ctrl-m:execute:
      (grep -o '[a-f0-9]\{7\}' | head -1 |
      xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      {}
      FZF-EOF"
}

# Search z history with fzf
fz() {
	[ $# -gt 0 ] && _z "$*" && return
	cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# Browse Brave history
fbh() {
	local cols sep
	cols=$((COLUMNS / 3))
	sep='{{::}}'

	# Copy History DB to circumvent the lock
	# See http://stackoverflow.com/questions/8936878 for the file path
	cp -f ~/Library/Application\ Support/BraveSoftware/Brave-Browser/Default/History /tmp/h

	sqlite3 -separator $sep /tmp/h \
		"select substr(title, 1, $cols), url
    from urls order by last_visit_time desc" |
		awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
		fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

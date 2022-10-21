# *** *** Configuration *** ***

CASE_SENSITIVE="true"          # Case-sensitive completion
DISABLE_AUTO_TITLE="true"      # Disable auto-setting terminal title
COMPLETION_WAITING_DOTS="true" # Red dots while waiting for completion

# Autosuggest Highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7,bg=bold,underline"

export KEYTIMEOUT=1
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export GIT_EDITOR=nvim
export EDITOR=nvim

# Fish shell like syntax highlighting for zsh
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$(brew --prefix)/share/zsh-syntax-highlighting/highlighters"

# Base16 Shell
source ~/.config/base16-shell/base16-shell.plugin.zsh

# FD
FD_OPTIONS="--follow --exclude .git --exclude node_modules"

export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS='--no-height'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# rbenv
export RBENV_ROOT="$HOME/.rbenv/"

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Rancher
export PATH="$HOME/.rd/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# Conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Man
export MANPATH="/usr/local/man:$MANPATH"

# Bat
export BAT_PAGER="less -R"

# Starship
eval "$(starship init zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Path
path=(
  $HOME/.dotfiles/bin
  $HOME/.local/bin
  /usr/local/sbin
  $path
)

# Bindkey
bindkey -v
bindkey -M viins '^r' fzf-history-widget # (r)everse history search
bindkey -M viins '^f' fzf-file-widget    # (f)ile / (t)
bindkey -M viins '^z' fzf-cd-widget      # (z) jump


# *** *** Functions *** ***

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
function update () {
  brew update && brew outdated && brew upgrade && brew cleanup
  sudo gem update --system && sudo gem update && gem cleanup all
  pip install --upgrade pip
  pip list -o --format columns|  cut -d' ' -f1|xargs -n1 pip install -U
  npm update npm -g
  npm update -g
  nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  nvim +Mason +15sleep +qall
  sudo softwareupdate -i -a
}

function homebrewBackup () {
  cd ~/.dotfiles/
  brew bundle dump --describe -f
}

function homebrewRestore () {
  brew bundle --file ~/.dotfiles/Brewfile
}

# Encode images in Base64
encodeBase64() {
  uuencode -m $1 /dev/stdout | sed '1d' | sed '$d'
}

# Create a data URL from a file
dataurl() {
  local mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Server
server() {
  browser-sync start --server --files "**"
}

# Determine size of a file or total size of a directory
fs() {
  if du -b /dev/null > /dev/null 2>&1; then
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

# Manually remove a downloaded app or file from the quarantine
unquarantine() {
  for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
    xattr -r -d "$attribute" "$@"
  done
}

# Auto change the nvm version based on a .nvmrc file based on the current directory.
# See https://github.com/creationix/nvm/issues/110#issuecomment-190125863
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
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
  if [ "$file" != "" ]
  then
    nvim $file
  fi
}

# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
  git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
  git branch --all | grep -v HEAD             |
  sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
  sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
  (echo "$tags"; echo "$branches") |
  fzf-tmux -- --no-hscroll --ansi +m -d "\t" -n 2) || return
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
  cols=$(( COLUMNS / 3 ))
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

# *** *** Plugins *** ***

# Load Antigen plugin manager
source ~/.dotfiles/.antigen/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle brew
antigen bundle bundler
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle docker
antigen bundle dotenv
antigen bundle extract
antigen bundle fzf
antigen bundle gem
antigen bundle git
antigen bundle git-extras
antigen bundle gitignore
antigen bundle gulp
antigen bundle history-substring-search
antigen bundle jira
antigen bundle man
antigen bundle node
antigen bundle npm
antigen bundle nvm
antigen bundle pip
antigen bundle pyenv
antigen bundle python
antigen bundle rbenv
antigen bundle rsync
antigen bundle ssh-agent
antigen bundle sudo
antigen bundle tmux
antigen bundle tmux-cssh
antigen bundle tmuxinator
antigen bundle vagrant
antigen bundle virtualenv
antigen bundle yarn
antigen bundle z
antigen bundle zsh-interactive-cd
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you’re done
antigen apply

# Additional zsh plugins
fpath=(~/.zsh.d/ $fpath)

# *** *** Aliases *** ***

# ZSH
alias zshconfig="vim $HOME/.zshrc"
alias reload="source $HOME/.zshrc"

# Folders
alias ...='cd ../..'
alias ..='cd ..'
alias cd..='cd ..'
alias ll='exa -l -g --icons'
alias lla='ll -a'
alias mkdir='mkdir -p'

# Git
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gd='git diff -- . ":(exclude)yarn.lock"' # Show differences between index and working tree
alias gdc='git diff --cached' # Show changes in next commit (differences between index and last commit)
alias gdh='git diff head' # Show difference between files in working tree and last commit
alias gdt='git difftool'
alias gfa='git fetch --all'
alias gg='git log'
alias ghi='git hist'
alias gho='$(git remote -v | grep github | sed -e "s/.*git\:\/\/\([a-z]\.\)*/\1/" -e "s/\.git$//g" -e "s/.*@\(.*\)$/\1/g" | tr ":" "/" | tr -d "\011" | sed -e "s/^/open http:\/\//g")'
alias gl='git pull'
alias glr='git pull --rebase'
alias glu='git config user.name "Stefan Imhoff" && git config user.email "stefan@imhoff.name";'
alias glx='git config user.name "Stefan Imhoff" && git config user.email "stefan.imhoff@xing.com";'
alias gmb='git merge-base master HEAD'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpp='PATCHNAME=`git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/"`-`date "+%Y-%m-%d-%H%M.patch"`; git diff --full-index master > ../patches/$PATCHNAME'
alias gpu='git push -u origin HEAD'
alias gpv='git push --no-verify'
alias grb='git rebase master'
alias grbc='git rebase --continue'
alias grbi='git rebase -i '
alias grbs='git rebase --skip'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gru='git remote update'
alias gsb='git show-branch'
alias gsl='git submodule foreach git pull'
alias gsquashall='merge_base_commit=$(git merge-base `git symbolic-ref -q HEAD` master); git rebase -i $merge_base_commit'
alias gst='git status -sb'
alias gsu='git submodule update'
alias gu='git up'
alias gw='git whatchanged'
alias gwp='git whatchanged -p'
alias lg='lazygit'
alias gw='git worktree'
alias gwl='git worktree list'
alias gwa='git worktree add' # <folder> <branch/hash>
alias gwr='git worktree remove' # <path/name>

# Vim
alias v='vim'

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Tmuxinator
alias mux="tmuxinator"

# Bat
alias cat="bat"

# iA Writer
alias ia='open $1 -a /Applications/iA\ Writer.app'

# Dotfiles folder
alias dotfiles="cd $HOME/.dotfiles"

# iCloud
alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"

# Pipe my public key to my clipboard
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

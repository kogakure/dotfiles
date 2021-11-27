# *** *** Plugins *** ***
# ***********************

# Load Antigen plugin manager
source ~/dotfiles/.antigen/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle git
antigen bundle pip

# Syntax highlighting bundle
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you’re done
antigen apply


# *** *** Aliases *** ***
# ***********************

# Folders
alias ...='cd ../..'
alias ..='cd ..'
alias cd..='cd ..'
alias la='ls -la'
alias ll='ls -lisa'
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

# Vim
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# iA Writer
alias ia='open $1 -a /Applications/iA\ Writer.app'

# Dotfiles folder
alias dotfiles="cd $HOME/dotfiles"

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


# *** *** Shell *** ***
# *********************

# Starship 
eval "$(starship init zsh)"


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

# *** *** Shell *** ***
# *********************

# Starship 

eval "$(starship init zsh)"

 #!/bin/sh

 # Manual install of nvm
git clone https://github.com/creationix/nvm.git ~/.nvm
cd ~/.nvm
git checkout `git describe --abbrev=0 --tags`
cd ~/.dotfiles/

# Reload nvm into this environment
export NVM_DIR="$HOME/.nvm/"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install stable
nvm alias default stable

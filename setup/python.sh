 #!/bin/sh

# Install Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Activate Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

pyenv install 2.7.17
pyenv install 3.8.5

pyenv virtualenv 2.7.17 neovim2
pyenv virtualenv 3.8.5 neovim3

pyenv activate neovim2
pip2 install neovim

pyenv activate neovim3
pip3 install neovim

pip3 install awscli

pyenv deactivate
 #!/bin/sh

# Install Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Activate Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.10.1

pip install fawkes
pip install autopep8
pip install black
pip install yamllint
pip install vim-vint
pip install gitlint
pip install codespell
pip install proselint
pip install flake8
pip install neovim
pip install awscli

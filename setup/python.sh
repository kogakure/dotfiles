 #!/bin/sh

# Install Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Activate Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.10.1

pip install autopep8
pip install awscli
pip install black
pip install certifi
pip install codespell
pip install fawkes
pip install flake8
pip install gitlint
pip install jupyter
pip install jupyter_ascending
pip install jupyterlab
pip install mutagen
pip install neovim
pip install notebook
pip install proselint
pip install pycryptodomex
pip install vim-vint
pip install voila
pip install websockets
pip install yamllint
pip install yt-dlp

jupyter nbextension install --py --sys-prefix jupyter_ascending
jupyter nbextension     enable jupyter_ascending --sys-prefix --py
jupyter serverextension enable jupyter_ascending --sys-prefix --py

conda install -n base ipykernel --update-deps --force-reinstall

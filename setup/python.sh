 #!/bin/sh

asdf plugin add python
asdf install python latest
asdf global python latest

pip install -r ~/.dotfiles/python/pip-requirements.txt

conda install -n base ipykernel --update-deps --force-reinstall
conda install --file ~/.dotfiles/python/conda-requirements.txt

# Include .profile if it exists
if [[ -f ~/.profile ]]; then
  source ~/.profile
fi

# Include .bashrc if it exists
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi

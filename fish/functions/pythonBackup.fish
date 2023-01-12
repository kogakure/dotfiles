function pythonBackup --description "Python backup"
  pip freeze > ~/.dotfiles/python/pip-requirements.txt
end

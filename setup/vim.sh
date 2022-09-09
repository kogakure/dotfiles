#!/bin/sh

nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim +Mason +15sleep +qall

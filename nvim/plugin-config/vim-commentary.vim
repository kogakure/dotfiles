" commentary.vim
" https://github.com/tpope/vim-commentary

autocmd FileType apache setlocal commentstring=#\ %s
autocmd FileType gspec setlocal commentstring=#\ %s
autocmd FileType eruby setlocal commentstring=<!--%s-->

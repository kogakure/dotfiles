" Vimux
" https://github.com/preservim/vimux

let g:VimuxHeight = "30"
let g:VimuxOrientation = 'h'
let g:VimuxUseNearestPane = 0

" Mappings
nmap <leader>vt  :VimuxTogglePane<CR>
nmap <leader>vp  :VimuxPromptCommand<CR>
nmap <leader>vl  :VimuxRunLastCommand<CR>
nmap <leader>vj  :RunJest<CR>
nmap <leader>vjb :RunJestOnBuffer<CR>
nmap <leader>vjf :RunJestFocused<CR>

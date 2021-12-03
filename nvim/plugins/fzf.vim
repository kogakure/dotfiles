" A command-line fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Key bindings
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Popup window centered on the screen
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" Enable per-command history
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Mappings
map <C-f> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>

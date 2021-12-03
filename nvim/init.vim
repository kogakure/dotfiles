" *** *** *** Global Settings *** *** ***
" ***************************************

set expandtab
set autowrite
set showbreak=↪
set ignorecase
set smartcase
set list
set listchars=tab:▸\ ,trail:·,nbsp:.,extends:❯,precedes:❮
set visualbell
set termguicolors
set number
set relativenumber
set backspace=indent,eol,start " Intuitive backspacing
set hidden
set iskeyword+=- " Add dashes to words
set cpoptions+=$ " Don't delete the word, but put a $ to the end till exit the mode
set title
set shortmess=caoOtI " Welcome screen
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set copyindent
set shiftround
set mouse=a
set clipboard=unnamedplus
set nowrap
set confirm
set spelllang=de_de,en_us
set timeoutlen=500
set signcolumn=yes:2
set foldmethod=marker
set splitbelow
set splitright
set scrolloff=8
set sidescrolloff=8
set virtualedit=all
set cursorline
set path+=**
set nobackup
set nowritebackup
set noswapfile
set undofile
set redrawtime=10000 " Allow more time for loading syntax on large files
set complete+=i,k,s,kspell
set wildmode=longest:full,full

" Spell Checker
set spellfile+=~/.config/nvim/spell/de.utf-8.add " (1)zg, (1)zw
set spellfile+=~/.vim/spell/en.utf-8.add " 2zg, 2zw

" Custom Dictionaries (<C-x> <C-k>)
set dictionary+=~/.config/nvim/dictionary/de_user.txt
set dictionary+=~/.config/nvim/dictionary/de_neu.txt
set dictionary+=~/.config/nvim/dictionary/en_us.txt

" Custom Thesauri (Synonyms) (<C-x> <C-t>)
set thesaurus+=~/.config/nvim/thesaurus/de_user.txt
set thesaurus+=~/.config/nvim/thesaurus/de_openthesaurus.txt

" Python paths
let g:python_host_prog=$HOME.'/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog=$HOME.'/.pyenv/versions/neovim3/bin/python'

" Leader
let mapleader = "\<space>"

" *** *** *** Key Mappings *** *** ***
" ************************************

" Quick toggle between buffers
noremap <leader>j :b#<CR>

" Add semicolon or comma to the end of the line
nnoremap ;; A;<ESC>
nnoremap ,, A,<ESC>

" Maintain the cursor position when yanking a visual selection
vnoremap y myy`y
vnoremap Y myY`y

" Delete last character of line
nnoremap <leader>x $x

" Open vim config in a new buffer, reload vim config
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete current buffer
nnoremap <silent> <leader>X :bd<CR>

" Delete all buffers
nnoremap <silent> <leader>da :bufdo bdelete<CR>

" Save current buffer
nnoremap <silent> <leader>sf :w<CR>

" Allow gf to open non-existent files
map gf :edit <cfile><CR>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Set spell checker to `s`
" zg (good), zG (good temp), zw (wrong), zW (wrong temp)
nnoremap <silent> <leader>s :set spell!<CR>

" Switch off highlighting
nnoremap <silent> <leader>h :nohlsearch<CR>

" Toogle list
nnoremap <leader>l :set list!<CR>

" Indent the whole source code
nnoremap <leader>ff gg=G''

" Reverse the mark mapping
nnoremap ' `
nnoremap ` '

" Visuall select of just pasted content
nnoremap gp `[v`]
nnoremap gy `[v`]y

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Open a quickfix window for the last search
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Faster linewise scrolling
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Keep the window centered
noremap G Gzzzv
noremap n nzzzv
noremap N Nzzzv
noremap } }zzzv
noremap { {zzzv

" Close all buffers
nnoremap XX :qa<CR>

" Add lines in NORMAL Mode
nnoremap gn o<ESC>k
nnoremap gN O<ESC>j

" Change to the folder of the current file
nnoremap <silent> <leader>cf :cd %:p:h<CR>:pwd<CR>

" Quickfix Window
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

" Exit INSERT MODE with 'jk'
inoremap jj <ESC>

" Reformat a line into a block
nnoremap <leader>q gqip

" Reformat a block into a line
nnoremap <leader>qq vipJ

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" *** *** *** Functions *** *** ***
" *********************************

" Toggle between soft wrap and no wrap
nnoremap <leader>tw :call ToggleWrap()<CR>

function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    set nowrap
    set nolinebreak
    set virtualedit=all
  else
    echo "Wrap ON"
    set wrap
    set linebreak
    set virtualedit=
    setlocal display+=lastline
  endif
endfunction


" *** *** *** Plugins *** *** ***
" *******************************

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/base16-vim.vim
source ~/.config/nvim/plugins/fzf.vim

call plug#end()
doautocmd User PlugLoaded


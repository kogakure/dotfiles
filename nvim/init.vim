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
set foldmethod=syntax
set splitbelow
set splitright
set scrolloff=8
set sidescrolloff=8
set virtualedit=all
set cursorline
set path+=**
set backup
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

" *** *** *** Key Mappings *** *** ***
" ************************************

let mapleader = "\<space>"

" Quick toggle between buffers
noremap <leader>j :b#<CR>

" Add semicolon or comma to the end of the line
nnoremap <leader>; A;<ESC>
nnoremap <leader>, A,<ESC>

" Delete last character of line
nnoremap <leader>x $x

" Open vim config in a new buffer, reload vim config
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete all buffers
nnoremap <silent> <leader>da :exec "1," . bufnr('$') . "bd"<CR>

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

" Navigation of buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>

" Exit INSERT MODE with 'jk'
inoremap jk <ESC>

" Reformat a line into a block
nnoremap <leader>q gqip

" Reformat a block into a line
nnoremap <leader>qq vipJ

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


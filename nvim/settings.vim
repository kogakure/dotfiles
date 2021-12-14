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
set completeopt=menu,menuone,preview
set wildmode=longest:full,full
set omnifunc=syntaxcomplete#Complete
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m

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

" Custom Colors
highlight ColorColumn guibg=#202224

" Show VCS conflict marker
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Leader
let mapleader = "\<space>"


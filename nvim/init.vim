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
set spelllang=de_de,en_us
set timeoutlen=500
set foldmethod=syntax
set splitbelow
set splitright
set scrolloff=8
set sidescrolloff=8
set virtualedit=all
set cursorline
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

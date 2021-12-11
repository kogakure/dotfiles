" *** *** *** Plugins *** *** ***
" *******************************

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

" Dashboard
Plug 'glepnir/dashboard-nvim'

" Color Themes
Plug 'chriskempson/base16-vim'

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/trouble.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'creativenull/diagnosticls-configs-nvim'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'David-Kunz/cmp-npm'

" File Management
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'dhruvmanila/telescope-bookmarks.nvim'
Plug 'tami5/sqlite.lua'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production',  'branch': 'release/0.x' }

" Custom Text Objects
Plug 'glts/vim-textobj-comment' " ac, ic, aC
Plug 'jceb/vim-textobj-uri' " au, iu, go
Plug 'kana/vim-textobj-datetime' " ada, add, adf, adt, adz, ida, …
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object' " ai, ii, aI, iI
Plug 'whatyouhide/vim-textobj-xmlattr' " ax, ix

" Custom Motions
Plug 'easymotion/vim-easymotion' " <Leader><Leader> (motion)

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Status Line
Plug 'hoob3rt/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Tpope
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'

" Misc
Plug 'APZelos/blamer.nvim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'karb94/neoscroll.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'sidebar-nvim/sidebar.nvim'
Plug 'windwp/nvim-autopairs'

call plug#end()
doautocmd User PlugLoaded

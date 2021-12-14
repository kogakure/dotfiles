" *** *** *** Plugins *** *** ***
" *******************************

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/trouble.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'creativenull/diagnosticls-configs-nvim'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'David-Kunz/cmp-npm'

" File Management & File Editing
Plug 'APZelos/blamer.nvim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'ThePrimeagen/harpoon'
Plug 'bogado/file-line'
Plug 'dhruvmanila/telescope-bookmarks.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'github/copilot.vim' " No API key jet :(
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lewis6991/gitsigns.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production',  'branch': 'release/0.x' }
Plug 'ruanyl/vim-gh-line'
Plug 'sidebar-nvim/sidebar.nvim'
Plug 'sudormrfbin/cheatsheet.nvim'
Plug 'tami5/sqlite.lua'
Plug 'vim-scripts/VisIncr'
Plug 'windwp/nvim-autopairs'
Plug 'elijahmanor/export-to-vscode.nvim'
Plug 'brooth/far.vim'

" Window Improvements
Plug 'akinsho/bufferline.nvim'
Plug 'chriskempson/base16-vim'
Plug 'dstein64/vim-startuptime'
Plug 'hoob3rt/lualine.nvim'
Plug 'junegunn/goyo.vim'
Plug 'karb94/neoscroll.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'wesQ3/vim-windowswap'
Plug 'yamatsum/nvim-cursorline'

" Syntax Highlighting
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'editorconfig/editorconfig-vim'
Plug 'jxnblk/vim-mdx-js'
Plug 'mattn/emmet-vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Custom Text Objects
Plug 'christoomey/vim-titlecase'
Plug 'glts/vim-textobj-comment' " ac, ic, aC
Plug 'jceb/vim-textobj-uri' " au, iu, go
Plug 'kana/vim-textobj-datetime' " ada, add, adf, adt, adz, ida, …
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object' " ai, ii, aI, iI
Plug 'whatyouhide/vim-textobj-xmlattr' " ax, ix

" Custom Motions
Plug 'christoomey/vim-sort-motion' " gs
Plug 'tommcdo/vim-exchange' " cx, cxx, X, cxc
Plug 'easymotion/vim-easymotion' " <Leader><Leader> (motion)

" Tpope
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'

" TMUX
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/vimux'
Plug 'tyewang/vimux-jest-test'

call plug#end()
doautocmd User PlugLoaded

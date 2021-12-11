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

" Completion
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Custom Motions
Plug 'easymotion/vim-easymotion' " <Leader><Leader> (motion)

" Status Line
Plug 'akinsho/bufferline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Tpope
Plug 'tpope/vim-abolish'

" Misc
Plug 'APZelos/blamer.nvim'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'karb94/neoscroll.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'windwp/nvim-autopairs'

call plug#end()
doautocmd User PlugLoaded

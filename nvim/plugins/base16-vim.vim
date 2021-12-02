" Base16 for Vim
Plug 'chriskempson/base16-vim'

function ActivateColorscheme()
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif
endfunction

augroup ActivateColorscheme
  autocmd!
  autocmd User PlugLoaded call ActivateColorscheme()
augroup END

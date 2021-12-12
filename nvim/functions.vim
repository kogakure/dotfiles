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

" Toggle between soft wrap and no wrap
nnoremap <leader>cw :call ToggleColorColumn()<CR>

function! ToggleColorColumn()
  if &colorcolumn == "80"
    echo "Textwidth OFF"
    set colorcolumn=0
    set textwidth=0
  else
    echo "Textwidth ON"
    set colorcolumn=80
    set textwidth=80
  endif
endfunction

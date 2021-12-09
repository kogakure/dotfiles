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

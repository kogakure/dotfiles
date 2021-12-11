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

" Automatic Tabular.vim with the (|)
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

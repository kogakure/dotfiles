" https://github.com/godlygeek/tabular

" Custom Tabular Commands
AddTabularPattern! equals       /^[^=]*\zs=/
AddTabularPattern! ruby_hash    /^[^=>]*\zs=>/
AddTabularPattern! commas       /,\s*\zs\s/l0
AddTabularPattern! colons       /^[^:]*:\s*\zs\s/l0

inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

" Automatic Tabular.vim with the (|)
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

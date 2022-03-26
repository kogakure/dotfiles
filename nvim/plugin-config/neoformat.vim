" Neoformat
" https://github.com/sbdchd/neoformat

" Settings
let g:neoformat_try_node_exe = 1
let g:neoformat_run_all_formatters = 1
let g:neoformat_basic_format_align = 0 " Disable alignment
let g:neoformat_basic_format_retab = 1 " Enable tab to spaces conversion
let g:neoformat_basic_format_trim  = 1 " Enable trimmming of trailing whitespace

" Mappings
nnoremap <silent> nf <cmd>Neoformat<CR>

" Auto Commands
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" Settings
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1

" Autocommands
augroup prettier
  autocmd!
  autocmd FileType css,scss let b:prettier_exec_cmd = 'prettier-stylelint'
  autocmd BufWritePre *.js   PrettierAsync
  autocmd BufWritePre *.jsx  PrettierAsync
  autocmd BufWritePre *.ts   PrettierAsync
  autocmd BufWritePre *.tsx  PrettierAsync
  autocmd BufWritePre *.css  PrettierAsync
  autocmd BufWritePre *.scss PrettierAsync
  autocmd BufWritePre *.md   PrettierAsync
augroup END

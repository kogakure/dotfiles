vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  " Automatically highlight yanked content
  augroup _highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup = 'Visual', timeout = 700})
  augroup END

  " Remember cursor position
  augroup _line_return
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
  augroup END

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
    autocmd BufRead,BufNewFile COMMIT_EDITMSG setfiletype git
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _ft_html
    autocmd!
    autocmd FileType html,eruby,njk setlocal foldmethod=indent
    autocmd FileType html,eruby,njk setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd Filetype html,eruby,njk setlocal ts=2 sts=2 sw=2 expandtab
  augroup END

  augroup _ft_css
    autocmd!
    autocmd FileType css setlocal foldmethod=marker
    autocmd FileType scss,sass,less,stylus setlocal foldmethod=indent
    autocmd FileType css setlocal foldmarker={,}
    autocmd FileType css,scss,sass,less,stylus setlocal omnifunc=csscomplete#CompleteCSS
    autocmd Filetype css,scss,sass,less,stylus setlocal iskeyword+=-
    autocmd Filetype css,scss,sass,less,stylus setlocal ts=2 sts=2 sw=2 expandtab
  augroup END

  augroup _ft_xml
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd Filetype xml setlocal ts=2 sts=2 sw=2 expandtab
  augroup END

  augroup _ft_javascript
    autocmd!
    autocmd FileType javascript setlocal foldmethod=indent
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
    autocmd BufRead,BufNewFile *.es6 setfiletype javascript
    autocmd BufRead,BufNewFile *.jsx setfiletype javascript.jsx
  augroup END

  augroup _ft_json
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END

  augroup _ft_ruby
    autocmd!
    autocmd FileType ruby setlocal foldmethod=syntax
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType ruby let g:rubycomplete_buffer_loading = 1
    autocmd FileType ruby let g:rubycomplete_rails = 1
    autocmd FileType ruby let g:rubycomplete_classes_in_global = 1
  augroup END

  augroup _ft_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
  augroup END

  augroup _ft_misc
    autocmd!
    autocmd BufNewFile,BufRead *.handlebars set filetype=html syntax=handlebars
    autocmd BufNewFile,BufRead *.hb set filetype=html syntax=handlebars
    autocmd BufNewFile,BufRead *.hbs set filetype=html syntax=handlebars
    autocmd BufNewFile,BufRead *.njk set filetype=html syntax=handlebars
    autocmd BufNewFile,BufRead *.json set filetype=json
    autocmd BufNewFile,BufRead *.pcss set filetype=css syntax=scss
    autocmd BufNewFile,BufRead *.postcss set filetype=css syntax=scss
    autocmd BufNewFile,BufRead *.rss set filetype=xml
    autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
  augroup END

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _lsp
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.formatting()
  augroup end
]])
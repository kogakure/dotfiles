" *** *** *** Autocommands *** *** ***
" ************************************

" Automatically highlight yanked content
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" Remember cursor position
augroup line_return
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" HTML
augroup ft_html
  autocmd!
  autocmd FileType html,eruby setlocal foldmethod=indent
  autocmd FileType html,eruby setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd Filetype html,eruby setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" CSS
augroup ft_css
  autocmd!
  autocmd FileType css setlocal foldmethod=marker
  autocmd FileType scss,sass,less,stylus setlocal foldmethod=indent
  autocmd FileType css setlocal foldmarker={,}
  autocmd FileType css,scss,sass,less,stylus setlocal omnifunc=csscomplete#CompleteCSS
  autocmd Filetype css,scss,sass,less,stylus setlocal iskeyword+=-
  autocmd Filetype css,scss,sass,less,stylus setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" XML
augroup ft_xml
  autocmd!
  autocmd FileType xml setlocal foldmethod=indent
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd Filetype xml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" JavaScript
augroup ft_javascript
  autocmd!
  autocmd FileType javascript setlocal foldmethod=indent
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
  autocmd BufRead,BufNewFile *.es6 setfiletype javascript
  autocmd BufRead,BufNewFile *.jsx setfiletype javascript.jsx
augroup END

" JSON
augroup ft_json
  autocmd!
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

" Ruby
augroup ft_ruby
  autocmd!
  autocmd FileType ruby setlocal foldmethod=syntax
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType ruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby let g:rubycomplete_rails = 1
  autocmd FileType ruby let g:rubycomplete_classes_in_global = 1
augroup END

" Pandoc
augroup ft_pandoc
  autocmd!
  autocmd BufNewFile,BufFilePRe,BufRead *.pdc set filetype=markdown.pandoc
  autocmd BufNewFile,BufFilePRe,BufRead *.md set filetype=markdown.pandoc
  autocmd BufNewFile,BufFilePRe,BufRead *.markdown set filetype=markdown.pandoc
augroup END

" Vim
augroup ft_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" PHP
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Git commit messages syntax
autocmd BufRead,BufNewFile COMMIT_EDITMSG setfiletype git

" Makefile
autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab

" Yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Misc file types
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

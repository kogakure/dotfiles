" *** *** *** Key Mappings *** *** ***
" ************************************

" Quick toggle between buffers
noremap <leader>j :b#<CR>

" Add semicolon or comma to the end of the line
nnoremap ;; A;<ESC>
nnoremap ,, A,<ESC>

" Maintain the cursor position when yanking a visual selection
vnoremap y myy`y
vnoremap Y myY`y

" Delete last character of line
nnoremap <leader>x $x

" Open vim config in a new buffer, reload vim config
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete current buffer
nnoremap <silent> <leader>X :bd<CR>

" Delete all buffers
nnoremap <silent> <leader>da :bufdo bdelete<CR>

" Save current buffer
nnoremap <silent> <leader>sf :w<CR>

" Allow gf to open non-existent files
map gf :edit <cfile><CR>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Set spell checker to `s`
" zg (good), zG (good temp), zw (wrong), zW (wrong temp)
nnoremap <silent> <leader>s :set spell!<CR>

" Switch off highlighting
nnoremap <silent> <leader>h :nohlsearch<CR>

" Toogle list
nnoremap <leader>l :set list!<CR>

" Indent the whole source code
nnoremap <leader>pf gg=G''

" Reverse the mark mapping
nnoremap ' `
nnoremap ` '

" Visuall select of just pasted content
nnoremap gp `[v`]
nnoremap gy `[v`]y

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Open a quickfix window for the last search
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Faster linewise scrolling
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Keep the window centered
noremap G Gzzzv
noremap n nzzzv
noremap N Nzzzv
noremap } }zzzv
noremap { {zzzv

" Close all buffers
nnoremap XX :qa<CR>

" Add lines in NORMAL Mode
nnoremap gn o<ESC>k
nnoremap gN O<ESC>j

" Change to the folder of the current file
nnoremap <silent> <leader>cf :cd %:p:h<CR>:pwd<CR>

" Quickfix Window
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

" Exit INSERT MODE with 'jk'
inoremap jj <ESC>

" Reformat a line into a block
nnoremap <leader>q gqip

" Reformat a block into a line
nnoremap <leader>qq vipJ

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Mapping for easier OmniCompletion
inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>
inoremap <C-O> <C-X><C-O>

" Remap Jump to Tag
nnoremap ü <C-]>
nnoremap Ü <C-O>

" Open for Markdown in iA Writer
nnoremap <leader>ia :silent !open -a iA\ Writer.app '%:p'<CR>

" Custom Text Objects
let pairs = { ":" : ":",
      \ "." : ".",
      \ "<bar>" : "<bar>",
      \ "*" : "*",
      \ "-" : "-",
      \ "_" : "_" }

for [key, value] in items(pairs)
  exe "nnoremap ci".key." T".key."ct".value
  exe "nnoremap ca".key." F".key."cf".value
  exe "nnoremap vi".key." T".key."vt".value
  exe "nnoremap va".key." F".key."vf".value
  exe "nnoremap di".key." T".key."dt".value
  exe "nnoremap da".key." F".key."df".value
  exe "nnoremap yi".key." T".key."yt".value
  exe "nnoremap ya".key." F".key."yf".value
endfor

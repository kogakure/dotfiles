local opts = { noremap = true, silent = true }

-- Toggle between soft wrap and no wrap
vim.keymap.set("n", "<leader>tw", [[<cmd>call ToggleWrap()<CR>]], opts)

-- Toggle between soft wrap and no wrap
vim.keymap.set("n", "<leader>cc", [[<cmd>call ToggleColorColumn()<CR>]], opts)

vim.cmd([[
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

function! SpellEn()
  set spell
  set spelllang=en_us
  set spellfile=~/.config/nvim/spell/en.utf-8.add
endfunction

function! SpellDe()
  set spell
  set spelllang=de_de
  set spellfile=~/.config/nvim/spell/de.utf-8.add
endfunction
]])

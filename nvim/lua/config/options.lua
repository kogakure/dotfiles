-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.autowrite = true
vim.opt.backspace = { "indent", "eol", "start" } -- Intuitive backspacing
vim.opt.copyindent = true
vim.opt.foldlevel = 2
vim.opt.fillchars = "fold: "
vim.opt.cursorline = false
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.listchars = { tab = "↦ ", trail = "·", nbsp = ".", extends = "❯", precedes = "❮" }
vim.opt.showbreak = "↪"
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.title = true
vim.opt.swapfile = false
vim.opt.virtualedit = "block,insert"
vim.opt.conceallevel = 2

vim.opt.iskeyword:append("-") -- Add dashes to words
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Wildignore
vim.opt.complete:append({ "i", "k", "s", "kspell" })

vim.g.nonels_supress_issue58 = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- FIXME: When using "vim.opt.spellfile:append("~/.config/…) the file is not writable"
vim.cmd([[
" Spell Checker
set spellfile+=~/.config/nvim/spell/en.utf-8.add

" Custom Dictionaries (<C-x> <C-k>)
set dictionary+=~/.config/nvim/dictionary/de_user.txt
set dictionary+=~/.config/nvim/dictionary/de_neu.txt
set dictionary+=~/.config/nvim/dictionary/en_us.txt

" Custom Thesauri (Synonyms) (<C-x> <C-t>)
set thesaurus+=~/.config/nvim/thesaurus/de_user.txt
set thesaurus+=~/.config/nvim/thesaurus/de_openthesaurus.txt
]])

-- :help options
local options = {
	autowrite = true,
	backspace = { "indent", "eol", "start" }, -- Intuitive backspacing
	backup = false,
	clipboard = "unnamedplus",
	completeopt = { "menu", "menuone", "preview" },
	confirm = true,
	copyindent = true,
	cursorline = false,
	expandtab = true,
	foldlevel = 2,
	foldlevelstart = 99,
	foldmethod = "syntax",
	foldnestmax = 10,
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg\\ --vimgrep\\ --no-heading\\ --smart-case",
	hidden = true,
	ignorecase = true,
	laststatus = 3,
	list = false,
	listchars = {
		tab = "↦ ",
		trail = "·",
		nbsp = ".",
		extends = "❯",
		precedes = "❮",
	},
	mouse = "a",
	number = true,
	omnifunc = "syntaxcomplete#Complete",
	redrawtime = 10000, -- Allow more time for loading syntax on large files
	relativenumber = true,
	scrolloff = 8,
	shiftround = true,
	shiftwidth = 4,
	shortmess = "caoOtI", -- Welcome screen
	showbreak = "↪",
	sidescrolloff = 8,
	signcolumn = "yes:2",
	smartcase = true,
	softtabstop = 4,
	spelllang = "en_us",
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 4,
	termguicolors = true,
	timeoutlen = 300,
	title = true,
	undofile = true,
	virtualedit = "all",
	visualbell = true,
	wildmode = { "longest:full", "full" },
	wrap = false,
	writebackup = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Add dashes to words
vim.opt.iskeyword:append("-")

-- Don’t delete the word, but put a $ to the end till exit the mode
vim.opt.cpoptions:append("$")

-- Wildignore
vim.opt.wildignore:append({ "*/node_modules/*" })

vim.opt.path:append("**")
vim.opt.complete:append({ "i", "k", "s", "kspell" })

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

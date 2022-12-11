-- https://github.com/kevinhwang91/nvim-ufo
local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
	return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Options
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

ufo.setup()

-- Keymaps
keymap("n", "zR", require("ufo").openAllFolds, opts)
keymap("n", "zM", require("ufo").closeAllFolds, opts)

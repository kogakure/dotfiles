-- https://github.com/kevinhwang91/nvim-ufo
local opts = { noremap = true, silent = true }

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds, opts)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, opts)

require("ufo").setup()

-- https://github.com/mrjones2014/legendary.nvim
local legendary = require("legendary")
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "LL", "<CMD>Legendary<CR>", opts)

legendary.setup({ which_key = { auto_register = true } })

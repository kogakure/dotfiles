-- https://github.com/mrjones2014/legendary.nvim
local status, legendary = pcall(require, "legendary")
if not status then
	return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

legendary.setup({ which_key = { auto_register = true } })

-- Keymaps
keymap("n", "LL", "<CMD>Legendary<CR>", opts)

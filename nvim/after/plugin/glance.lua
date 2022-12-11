-- https://github.com/DNLHC/glance.nvim
local status_ok, glance = pcall(require, "glance")
if not status_ok then
	return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

glance.setup()

-- Keymaps
keymap("n", "gld", "<CMD>Glance definitions<CR>", opts)
keymap("n", "gli", "<CMD>Glance implementations<CR>", opts)
keymap("n", "glr", "<CMD>Glance references<CR>", opts)
keymap("n", "glt", "<CMD>Glance type_definitions<CR>", opts)

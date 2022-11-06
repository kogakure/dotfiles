-- https://github.com/APZelos/blamer.nvim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.blamer_enabled = 0
vim.g.blamer_relative_time = 1
vim.g.blamer_delay = 200

-- Keymaps
keymap("n", "<leader>tb", [[<Cmd>BlamerToggle<CR>]], opts)

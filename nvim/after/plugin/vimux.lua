-- https://github.com/preservim/vimux
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.VimuxHeight = "30"
vim.g.VimuxOrientation = "h"
vim.g.VimuxUseNearestPane = 0

-- Keymaps
keymap("n", "<leader>vt", [[<cmd>VimuxTogglePane<CR>]], opts)
keymap("n", "<leader>vp", [[<cmd>VimuxPromptCommand<CR>]], opts)
keymap("n", "<leader>vl", [[<cmd>VimuxRunLastCommand<CR>]], opts)
keymap("n", "<leader>vj", [[<cmd>RunJest<CR>]], opts)
keymap("n", "<leader>vjb", [[<cmd>RunJestOnBuffer<CR>]], opts)
keymap("n", "<leader>vjf", [[<cmd>RunJestFocused<CR>]], opts)

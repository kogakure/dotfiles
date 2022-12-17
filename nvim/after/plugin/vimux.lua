-- https://github.com/preservim/vimux
local opts = { noremap = true, silent = true }

vim.g.VimuxHeight = "30"
vim.g.VimuxOrientation = "h"
vim.g.VimuxUseNearestPane = 0

vim.keymap.set("n", "<leader>vt", [[<cmd>VimuxTogglePane<CR>]], opts)
vim.keymap.set("n", "<leader>vp", [[<cmd>VimuxPromptCommand<CR>]], opts)
vim.keymap.set("n", "<leader>vl", [[<cmd>VimuxRunLastCommand<CR>]], opts)
vim.keymap.set("n", "<leader>vj", [[<cmd>RunJest<CR>]], opts)
vim.keymap.set("n", "<leader>vjb", [[<cmd>RunJestOnBuffer<CR>]], opts)
vim.keymap.set("n", "<leader>vjf", [[<cmd>RunJestFocused<CR>]], opts)

-- nvim-tree.lua
-- https://github.com/kyazdani42/nvim-tree.lua

local status, nvim_tree = pcall(require, 'nvim-tree')
if (not status) then return end

nvim_tree.setup({})

--- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>nt',  [[<Cmd>:NvimTreeToggle<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>ntr', [[<Cmd>:NvimTreeRefresh<CR>]], opts)

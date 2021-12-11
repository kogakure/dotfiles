-- Trouble
-- https://github.com/folke/trouble.nvim

local status, trouble = pcall(require, 'trouble')
if (not status) then return end

trouble.setup()

--- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>tt', [[<Cmd>:TroubleToggle<CR>]], opts)

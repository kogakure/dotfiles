-- lualine.nvim
-- https://github.com/nvim-lualine/lualine.nvim

local status, lualine = pcall(require, 'lualine')
if (not status) then return end

lualine.setup()

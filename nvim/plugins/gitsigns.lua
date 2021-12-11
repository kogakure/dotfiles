-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim

local status, gitsigns = pcall(require, 'gitsigns')
if (not status) then return end

gitsigns.setup()

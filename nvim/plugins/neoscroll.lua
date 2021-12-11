-- Neoscroll
-- https://github.com/karb94/neoscroll.nvim

local status, neoscroll = pcall(require, 'neoscroll')
if (not status) then return end

neoscroll.setup()

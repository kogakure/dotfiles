-- lspkind-nvim
-- https://github.com/onsails/lspkind-nvim

local status, lspkind = pcall(require, 'lspkind')
if (not status) then return end

lspkind.init({})

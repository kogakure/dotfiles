-- https://github.com/DNLHC/glance.nvim
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "gld", "<CMD>Glance definitions<CR>", opts)
vim.keymap.set("n", "gli", "<CMD>Glance implementations<CR>", opts)
vim.keymap.set("n", "glr", "<CMD>Glance references<CR>", opts)
vim.keymap.set("n", "glt", "<CMD>Glance type_definitions<CR>", opts)

require("glance").setup()

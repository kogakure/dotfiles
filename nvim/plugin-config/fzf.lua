-- fzf.nvim
-- https://github.com/nvim-telescope/telescope.nvim/

--- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<C-p>',       [[<Cmd>Files<CR>]],     opts)
vim.api.nvim_set_keymap('n', '<Leader>b',   [[<Cmd>Buffers<CR>]],   opts)
vim.api.nvim_set_keymap('n', '<Leader>gs',  [[<Cmd>GFiles?<CR>]],   opts)
vim.api.nvim_set_keymap('n', '<Leader>fc',  [[<Cmd>Commits<CR>]],   opts)
vim.api.nvim_set_keymap('n', '<Leader>fbc', [[<Cmd>BCommits<CR>]],  opts)
vim.api.nvim_set_keymap('n', '<Leader>ht',  [[<Cmd>Helptags<CR>]],  opts)
vim.api.nvim_set_keymap('n', '<Leader>r',   [[<Cmd>Rg<CR>]],        opts)
vim.api.nvim_set_keymap('n', '<Leader>rf',  [[<Cmd>Rg!<CR>]],       opts)
vim.api.nvim_set_keymap('n', '<Leader>t',   [[<Cmd>Tags<CR>]],      opts)
vim.api.nvim_set_keymap('n', '<Leader>m',   [[<Cmd>Marks<CR>]],     opts)
vim.api.nvim_set_keymap('n', '<Leader>km',  [[<Cmd>Maps<CR>]],      opts)
vim.api.nvim_set_keymap('n', '<Leader>fl',  [[<Cmd>Lines<CR>]],     opts)
vim.api.nvim_set_keymap('n', '<Leader>fbl', [[<Cmd>BLines<CR>]],    opts)
vim.api.nvim_set_keymap('n', '<Leader>w',   [[<Cmd>Windows<CR>]],   opts)
vim.api.nvim_set_keymap('n', '<Leader>mru', [[<Cmd>History<CR>]],   opts)
vim.api.nvim_set_keymap('n', '<Leader>ch',  [[<Cmd>History:<CR>]],  opts)
vim.api.nvim_set_keymap('n', '<Leader>sh',  [[<Cmd>History/<CR>]],  opts)
vim.api.nvim_set_keymap('n', '<Leader>fs',  [[<Cmd>Snippets<CR>]],  opts)
vim.api.nvim_set_keymap('n', '<Leader>ff',  [[<Cmd>Filetypes<CR>]], opts)

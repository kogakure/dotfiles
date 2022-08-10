-- vim-easymotion – https://github.com/easymotion/vim-easymotion
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Keymaps
-- <Leader>f{char} to move to {char}
keymap("", "<leader>l", [[<Plug>(easymotion-bd-f)]], opts)
keymap("n", "<leader>l", [[<Plug>(easymotion-overwin-f)]], opts)

-- Move to line
keymap("", "<leader>L", [[<Plug>(easymotion-bd-jk)]], opts)
keymap("n", "<leader>L", [[<Plug>(easymotion-overwin-line)]], opts)

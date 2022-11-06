--- https://github.com/elijahmanor/export-to-vscode.nvim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Keymaps
keymap("n", "<leader>code", [[<Cmd>lua require("export-to-vscode").launch()<CR>]], opts)

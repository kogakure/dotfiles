--- export-to-vscode.nvim
-- https://github.com/elijahmanor/export-to-vscode.nvim

vim.api.nvim_set_keymap('n', '<leader>code', '<cmd>lua require("export-to-vscode").launch()<cr>', { noremap = true, silent = true })

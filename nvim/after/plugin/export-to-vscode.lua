--- https://github.com/elijahmanor/export-to-vscode.nvim
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>code", [[<Cmd>lua require("export-to-vscode").launch()<CR>]], opts)

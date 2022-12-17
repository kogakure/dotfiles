-- https://github.com/ibhagwan/fzf-lua
local opts = { noremap = true, silent = true }

require("fzf-lua").setup({
	lsp = {
		async_or_timeout = 3000, -- make lsp requests synchronous so they work with null-ls
	},
})

vim.keymap.set("n", "<leader>zbl", [[<Cmd>FzfLua blines<CR>]], opts)
vim.keymap.set("n", "<leader>zf", [[<Cmd>FzfLua Files<CR>]], opts)
vim.keymap.set("n", "<leader>zg", [[<Cmd>FzfLua Grep<CR>]], opts)
vim.keymap.set("n", "<leader>zgb", [[<Cmd>FzfLua git_branches<CR>]], opts)
vim.keymap.set("n", "<leader>zgc", [[<Cmd>FzfLua git_commits<CR>]], opts)
vim.keymap.set("n", "<leader>zgl", [[<Cmd>FzfLua grep_last<CR>]], opts)
vim.keymap.set("n", "<leader>zgp", [[<Cmd>FzfLua grep_project<CR>]], opts)
vim.keymap.set("n", "<leader>zgs", [[<Cmd>FzfLua git_status<CR>]], opts)
vim.keymap.set("n", "<leader>zgst", [[<Cmd>FzfLua git_stash<CR>]], opts)
vim.keymap.set("n", "<leader>zgv", [[<Cmd>FzfLua grep_visual<CR>]], opts)
vim.keymap.set("n", "<leader>zgw", [[<Cmd>FzfLua grep_cword<CR>]], opts)
vim.keymap.set("n", "<leader>zh", [[<Cmd>FzfLua oldfiles<CR>]], opts)
vim.keymap.set("n", "<leader>zl", [[<Cmd>FzfLua lines<CR>]], opts)
vim.keymap.set("n", "<leader>zlca", [[<Cmd>FzfLua code_actions<CR>]], opts)
vim.keymap.set("n", "<leader>zld", [[<Cmd>FzfLua lsp_definitions<CR>]], opts)
vim.keymap.set("n", "<leader>zlds", [[<Cmd>FzfLua lsp_document_symbols<CR>]], opts)
vim.keymap.set("n", "<leader>zlg", [[<Cmd>FzfLua live_grep<CR>]], opts)
vim.keymap.set("n", "<leader>zlgr", [[<Cmd>FzfLua live_grep_resume<CR>]], opts)
vim.keymap.set("n", "<leader>zlr", [[<Cmd>FzfLua lsp_references<CR>]], opts)
vim.keymap.set("n", "<leader>zltd", [[<Cmd>FzfLua lsp_typedef<CR>]], opts)
vim.keymap.set("n", "<leader>zlws", [[<Cmd>FzfLua lsp_live_workspace_symbols<CR>]], opts)
vim.keymap.set("n", "<leader>zm", [[<Cmd>FzfLua marks<CR>]], opts)
vim.keymap.set("n", "<leader>zqfq", [[<Cmd>FzfLua quickfix<CR>]], opts)
vim.keymap.set("n", "<leader>zr", [[<Cmd>FzfLua resume<CR>]], opts)
vim.keymap.set("n", "<leader>zss", [[<Cmd>FzfLua spell_suggest<CR>]], opts)
vim.keymap.set("n", "<leader>ztg", [[<Cmd>FzfLua tabs<CR>]], opts)

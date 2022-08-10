-- fzf-lua – https://github.com/ibhagwan/fzf-lua
local cmp_status_ok, fzf_lua = pcall(require, "fzf-lua")
if not cmp_status_ok then
	return
end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

fzf_lua.setup({
	lsp = {
		async_or_timeout = 3000, -- make lsp requests synchronous so they work with null-ls
	},
})

-- Keymaps
keymap("n", "<C-p>", [[<Cmd>:FzfLua files<CR>]], opts)
keymap("n", "<leader>b", [[<Cmd>:FzfLua buffers<CR>]], opts)
keymap("n", "<leader>zbl", [[<Cmd>:FzfLua blines<CR>]], opts)
keymap("n", "<leader>zf", [[<Cmd>:FzfLua files<CR>]], opts)
keymap("n", "<leader>zg", [[<Cmd>:FzfLua grep<CR>]], opts)
keymap("n", "<leader>zgb", [[<Cmd>:FzfLua git_branches<CR>]], opts)
keymap("n", "<leader>zgc", [[<Cmd>:FzfLua git_commits<CR>]], opts)
keymap("n", "<leader>zgl", [[<Cmd>:FzfLua grep_last<CR>]], opts)
keymap("n", "<leader>zgp", [[<Cmd>:FzfLua grep_project<CR>]], opts)
keymap("n", "<leader>zgs", [[<Cmd>:FzfLua git_status<CR>]], opts)
keymap("n", "<leader>zgst", [[<Cmd>:FzfLua git_stash<CR>]], opts)
keymap("n", "<leader>zgv", [[<Cmd>:FzfLua grep_visual<CR>]], opts)
keymap("n", "<leader>zgw", [[<Cmd>:FzfLua grep_cword<CR>]], opts)
keymap("n", "<leader>zh", [[<Cmd>:FzfLua oldfiles<CR>]], opts)
keymap("n", "<leader>zl", [[<Cmd>:FzfLua lines<CR>]], opts)
keymap("n", "<leader>zlca", [[<Cmd>:FzfLua code_actions<CR>]], opts)
keymap("n", "<leader>zld", [[<Cmd>:FzfLua lsp_definitions<CR>]], opts)
keymap("n", "<leader>zlds", [[<Cmd>:FzfLua lsp_document_symbols<CR>]], opts)
keymap("n", "<leader>zlg", [[<Cmd>:FzfLua live_grep<CR>]], opts)
keymap("n", "<leader>zlgr", [[<Cmd>:FzfLua live_grep_resume<CR>]], opts)
keymap("n", "<leader>zlr", [[<Cmd>:FzfLua lsp_references<CR>]], opts)
keymap("n", "<leader>zltd", [[<Cmd>:FzfLua lsp_typedef<CR>]], opts)
keymap("n", "<leader>zlws", [[<Cmd>:FzfLua lsp_live_workspace_symbols<CR>]], opts)
keymap("n", "<leader>zm", [[<Cmd>:FzfLua marks<CR>]], opts)
keymap("n", "<leader>zqfq", [[<Cmd>:FzfLua quickfix<CR>]], opts)
keymap("n", "<leader>zr", [[<Cmd>:FzfLua resume<CR>]], opts)
keymap("n", "<leader>zss", [[<Cmd>:FzfLua spell_suggest<CR>]], opts)
keymap("n", "<leader>ztg", [[<Cmd>:FzfLua tabs<CR>]], opts)

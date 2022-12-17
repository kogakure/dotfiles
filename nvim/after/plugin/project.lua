-- https://github.com/ahmedkhalf/project.nvim
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pm", [[<Cmd>:Telescope projects<CR>]], opts)

require("project_nvim").setup({
	active = true,
	on_config_done = nil,
	manual_mode = false,
	detection_methods = {
		"pattern",
	},
	patterns = {
		".git",
		"Makefile",
		".gitignore",
		"package.json",
		"!node_modules",
	},
	show_hidden = false,
	silent_chdir = true,
	ignore_lsp = {},
	datapath = vim.fn.stdpath("data"),
})

-- https://github.com/ahmedkhalf/project.nvim
local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
	return
end

project.setup({
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

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>pm", [[<Cmd>:Telescope projects<CR>]], opts)

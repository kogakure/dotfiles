-- https://github.com/kyazdani42/nvim-tree.lua
vim.opt.termguicolors = true

require("nvim-tree").setup({
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

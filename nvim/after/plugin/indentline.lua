-- https://github.com/lukas-reineke/indent-blankline.nvim
local indent_blankline = require("indent_blankline")

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { bg = "#1f1f1f", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { bg = "#1a1a1a", nocombine = true })

indent_blankline.setup({
	char = "",
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	space_char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	show_trailing_blankline_indent = false,
})

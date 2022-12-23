-- https://github.com/xiyaowong/nvim-transparent
require("transparent").setup({
	enable = false,
	extra_groups = {
		"BufferLineBackground",
		"BufferLineFill",
		"BufferLineIndicatorSelected",
		"BufferLineSeparator",
		"BufferLineTabClose",
		"BufferlineBufferSelected",
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"NvimTreeNormal",
		"TelescopeNormal",
	},
	exclude = {}, -- table: groups you don't want to clear
})

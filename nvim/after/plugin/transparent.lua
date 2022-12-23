-- https://github.com/xiyaowong/nvim-transparent
require("transparent").setup({
	enable = true,
	extra_groups = {
		"NvimTreeNormal",
		"BufferLineTabClose",
		"BufferlineBufferSelected",
		"BufferLineFill",
		"BufferLineBackground",
		"BufferLineSeparator",
		"BufferLineIndicatorSelected",
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	exclude = {}, -- table: groups you don't want to clear
})

-- https://github.com/nvim-treesitter/nvim-treesitter-context
require("treesitter-context").setup({
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
	},
})

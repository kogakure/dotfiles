-- Plugin to improve viewing Markdown files in Neovim
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		file_types = { "markdown", "mdx", "norg", "rmd", "org" },
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = false,
			icons = {},
		},
	},
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
}

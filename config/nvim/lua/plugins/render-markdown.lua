-- Plugin to improve viewing Markdown files in Neovim
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		file_types = { "markdown", "mdx" },
	},
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
}

-- Nvim Treesitter configurations
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		indent = { enable = true }, -- previously "false"
		highlight = { enable = true },
		folds = { enable = true },
		ensure_installed = {
			"astro",
			"bash",
			"css",
			"fish",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"graphql",
			"html",
			"http",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"scss",
			"sql",
			"svelte",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
	},
	config = function()
		-- Add custom filetypes
		vim.filetype.add({
			extension = {
				mdx = "mdx",
				rss = "rss",
			},
		})

		vim.treesitter.language.register("markdown", "mdx")
		vim.treesitter.language.register("xml", "rss")
	end,
}

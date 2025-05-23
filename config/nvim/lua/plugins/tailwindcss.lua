-- Tailwind CSS
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {},
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
		-- {
		--   "hrsh7th/nvim-cmp",
		--   dependencies = {
		--     { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
		--   },
		--   opts = function(_, opts)
		--     -- original LazyVim kind icon formatter
		--     local format_kinds = opts.formatting.format
		--     opts.formatting.format = function(entry, item)
		--       format_kinds(entry, item) -- add icons
		--       return require("tailwindcss-colorizer-cmp").formatter(entry, item)
		--     end
		--   end,
		-- },
		"laytan/tailwind-sorter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
		},
		build = "cd formatter && npm i && npm run build",
		config = {
			on_save_enabled = true,
			on_save_pattern = { "*.html", "*.jsx", "*.tsx", "*.astro", "*.svelte" },
		},
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
}

-- Linting
-- https://github.com/mfussenegger/nvim-lint
local HOME = os.getenv("HOME")

return {
	"mfussenegger/nvim-lint",
	event = {
		"BufWritePre",
		"BufNewFile",
	},
	keys = {
		{
			"<leader>L",
			mode = { "n" },
			function()
				require("lint").try_lint()
			end,
			desc = "Trigger linting for current file",
		},
	},
	opts = {
		events = { "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave" },
		linters = {
			-- https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
			["markdownlint-cli2"] = {
				args = { "--config", HOME .. "/.markdownlint.yaml", "--" },
			},
		},
		linters_by_ft = {
			["*"] = { "codespell" },
			["astro"] = { "eslint_d", "cspell" },
			["fish"] = { "fish" },
			["javascript"] = { "eslint_d", "cspell" },
			["javascriptreact"] = { "eslint_d", "cspell" },
			["markdown"] = { "markdownlint-cli2" },
			["python"] = { "pylint" },
			["ruby"] = { "rubocop" },
			["svelte"] = { "eslint_d" },
			["typescript"] = { "eslint_d", "cspell" },
			["typescriptreact"] = { "eslint_d", "cspell" },
		},
	},
}

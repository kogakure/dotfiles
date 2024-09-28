-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufNewFile" },
	keys = {
		{
			"<leader>mp",
			mode = { "n", "v" },
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end,
			desc = "Format file or range (in visual mode)",
		},
	},
	opts = {
		formatters = {
			["eslint_d"] = {
				command = "eslint_d",
				args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
				stdin = true,
			},
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
				end,
			},
			["markdownlint-cli2"] = {
				condition = function(_, ctx)
					local diag = vim.tbl_filter(function(d)
						return d.source == "markdownlint"
					end, vim.diagnostic.get(ctx.buf))
					return #diag > 0
				end,
			},
			["nixpkgs_fmt"] = {
				command = "nixpkgs-fmt",
			},
		},
		formatters_by_ft = {
			-- ["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
			["astro"] = { { "prettierd", "prettier" } },
			["css"] = { { "prettierd", "prettier" }, "stylelint" },
			["eruby"] = { "htmlbeautifier" },
			["fish"] = { "fish_indent" },
			["go"] = { "goimports", "gofumpt" },
			["graphql"] = { { "prettierd", "prettier" } },
			["html"] = { { "prettierd", "prettier" } },
			["javascript"] = { { "prettierd", "prettier" }, "eslint_d" },
			["javascriptreact"] = { { "prettierd", "prettier" }, "eslint_d" },
			["json"] = { { "prettierd", "prettier" } },
			["lua"] = { "stylua" },
			["markdown"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
			["markdown.mdx"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
			["mdx"] = { { "prettierd", "prettier" } },
			["nix"] = { "nixpkgs_fmt" },
			["python"] = { "isort", "black" },
			["ruby"] = { "rubyfmt", "rubocop" },
			["svelte"] = { { "prettierd", "prettier" } },
			["typescript"] = { { "prettierd", "prettier" }, "eslint_d" },
			["typescriptreact"] = { { "prettierd", "prettier" }, "eslint_d" },
			["yaml"] = { { "prettierd", "prettier" } },
		},
	},
}

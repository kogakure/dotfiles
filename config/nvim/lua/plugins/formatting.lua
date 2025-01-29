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
		-- formatters = {
		["markdown-toc"] = {
			condition = function(_, ctx)
				for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
					if line:find("<!%-%-% toc %-%->") then
						return true
					end
				end
			end,
			stop_after_first = true,
		},
		["markdownlint-cli2"] = {
			condition = function(_, ctx)
				local diag = vim.tbl_filter(function(d)
					return d.source == "markdownlint"
				end, vim.diagnostic.get(ctx.buf))
				return #diag > 0
			end,
			stop_after_first = true,
		},
		formatters_by_ft = {
			["_"] = { "trim_whitespace" },
			["astro"] = { { "prettierd", "prettier", stop_after_first = true } },
			["css"] = { { "prettierd", "prettier", stop_after_first = true }, "stylelint" },
			["eruby"] = { "htmlbeautifier" },
			["fish"] = { "fish_indent" },
			["go"] = { "goimports", "gofumpt" },
			["graphql"] = { { "prettierd", "prettier", stop_after_first = true } },
			["html"] = { { "prettierd", "prettier", stop_after_first = true } },
			["json"] = { { "prettierd", "prettier", stop_after_first = true } },
			["lua"] = { "stylua" },
			["markdown"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
			["markdown.mdx"] = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
			["mdx"] = { { "prettierd", "prettier", stop_after_first = true } },
			["python"] = { "isort", "black" },
			["ruby"] = { "rubyfmt", "rubocop" },
			["svelte"] = { { "prettierd", "prettier", stop_after_first = true } },
			["yaml"] = { { "prettierd", "prettier", stop_after_first = true } },
		},
	},
}

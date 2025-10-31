-- Quickstart configs for Nvim LSP
-- https://github.com/neovim/nvim-lspconfig
return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = { enabled = false },
		servers = {
			["*"] = {
				keys = {
					{ "g0", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
				},
			},
			astro = {},
			cssls = {},
			cssmodules_ls = {},
			diagnosticls = {},
			emmet_ls = {},
			graphql = {},
			html = {},
			jsonls = {},
			lua_ls = {},
			svelte = {},
			denols = {
				root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
			},
			tsserver = {
				root_dir = require("lspconfig").util.root_pattern("package.json"),
				single_file_support = false,
			},
			yamlls = {},
		},
	},
}

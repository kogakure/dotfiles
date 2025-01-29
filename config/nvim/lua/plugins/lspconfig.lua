-- Quickstart configs for Nvim LSP
-- https://github.com/neovim/nvim-lspconfig
return {
	"neovim/nvim-lspconfig",
	init = function()
		require("lazyvim.util").lsp.on_attach(function(_, buffer)
	  -- stylua: ignore
      vim.keymap.set("n", "g0", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = buffer, desc = "Document Symbols" })
			vim.keymap.set("n", "cc", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = buffer, desc = "Code Action" })
		end)
	end,
	opts = {
		inlay_hints = { enabled = false },
		servers = {
			astro = {},
			cssls = {},
			cssmodules_ls = {},
			denols = {},
			diagnosticls = {},
			emmet_ls = {},
			graphql = {},
			html = {},
			jsonls = {},
			lua_ls = {},
			svelte = {},
			tsserver = {},
			yamlls = {},
		},
	},
	setup = function()
		local nvim_lsp = require("lspconfig")

		nvim_lsp.denols.setup({
			on_attach = on_attach,
			root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
		})

		nvim_lsp.tsserver.setup({
			on_attach = on_attach,
			root_dir = nvim_lsp.util.root_pattern("package.json"),
			single_file_support = false,
		})
	end,
}

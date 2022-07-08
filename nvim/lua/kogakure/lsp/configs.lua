local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local lspconfig = require("lspconfig")

local servers = {
	"cssls",
	"cssmodules_ls",
	"diagnosticls",
	"emmet_ls",
	"graphql",
	"html",
	"jsonls",
	"pyright",
	"quick_lint_js",
	"sumneko_lua",
	"tsserver",
}

lsp_installer.settings({
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},

	max_concurrent_installers = 4,
})

lsp_installer.setup({
	ensure_installed = servers,
})

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("kogakure.lsp.handlers").on_attach,
		capabilities = require("kogakure.lsp.handlers").capabilities,
	}

	local has_custom_opts, server_custom_opts = pcall(require, "kogakure.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end

	lspconfig[server].setup(opts)
end

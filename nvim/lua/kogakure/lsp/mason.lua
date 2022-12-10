local mason_status_ok, mason = pcall(require, "mason")
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
local mason_lsp_config_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local mason_null_ls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")

if not mason_status_ok then
	return
end

if not lspconfig_status_ok then
	return
end

if not mason_lsp_config_status_ok then
	return
end

if not mason_null_ls_status_ok then
	return
end

local servers = {
	"astro",
	"cssls",
	"cssmodules_ls",
	"diagnosticls",
	"emmet_ls",
	"golangci_lint_ls",
	"gopls",
	"graphql",
	"html",
	"jsonls",
	"pyright",
	"rust_analyzer",
	"sourcery",
	"sumneko_lua",
	"svelte",
	"tailwindcss",
	"theme_check",
	"tsserver",
	"vuels",
}

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},

	max_concurrent_installers = 4,
})

mason_null_ls.setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = true,
})

mason_lspconfig.setup({
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

local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client, bufnr)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Clear All the References",
		})
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap

	keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "g0", "<cmd>Telescope lsp_document_symbols<CR>", opts)
	keymap(bufnr, "n", "gD", "<cmd>FzfLua lsp_declarations<CR>", opts)
	keymap(bufnr, "n", "gF", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
	keymap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "gc", "<cmd>FzfLua lsp_code_actions<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)
	keymap(bufnr, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	keymap(bufnr, "n", "Ä", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	keymap(bufnr, "n", "ä", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
	-- Autosave
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end

	-- TypeScript
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- HTML
	if client.name == "html" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Stylelint
	if client.name == "stylelint_lsp" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- JSON
	if client.name == "jsonls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Lua
	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end

	-- Rust
	if client.name == "rust_analyzer" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Astro
	if client.name == "astro" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Diagnostic
	if client.name == "diagnosticls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)
	lsp_highlight_document(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M

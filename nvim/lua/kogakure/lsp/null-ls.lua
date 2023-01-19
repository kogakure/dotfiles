-- null-ls.nvim – https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local opts = { noremap = true, silent = true }

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
local hover = null_ls.builtins.hover
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = false,
	sources = {
		code_actions.eslint_d.with({ diagnostics_format = "[eslint] #{m}\n(#{c})" }),
		code_actions.gitrebase,
		code_actions.gitsigns,
		completion.luasnip,
		diagnostics.eslint_d,
		diagnostics.gitlint,
		diagnostics.golangci_lint,
		diagnostics.stylelint,
		diagnostics.tsc,
		diagnostics.vale,
		diagnostics.zsh,
		formatting.autopep8, -- Python
		formatting.black.with({ extra_args = { "--fast" } }), -- Python
		formatting.eslint_d,
		formatting.gofmt,
		formatting.goimports,
		formatting.goimports_reviser,
		formatting.prettierd,
		formatting.stylelint,
		formatting.trim_newlines,
		formatting.trim_whitespace,
		formatting.rustfmt,
		hover.dictionary,
	},
})

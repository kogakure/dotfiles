-- Indent Blankline – https://github.com/lukas-reineke/indent-blankline.nvim
local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

vim.opt.termguicolors = true
vim.cmd([[
highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine
highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine
]])

indent_blankline.setup({
	char = "",
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	space_char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	show_trailing_blankline_indent = false,
})

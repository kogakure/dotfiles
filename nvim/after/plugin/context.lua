-- nvim-treesitter-context – https://github.com/nvim-treesitter/nvim-treesitter-context
local status_ok, context = pcall(require, "treesitter-context")
if not status_ok then
	return
end

context.setup({
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
	},
})

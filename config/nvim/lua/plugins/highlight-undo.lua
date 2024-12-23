-- highlight-undo.nvim
-- https://github.com/tzachar/highlight-undo.nvim
return {
	"tzachar/highlight-undo.nvim",
	enabled = false,
	config = function()
		require("highlight-undo").setup({
			hlgroup = "HighlightUndo",
			duration = 300,
			keymaps = {
				{ "n", "u", "undo", {} },
				{ "n", "<C-r>", "redo", {} },
			},
		})
	end,
}

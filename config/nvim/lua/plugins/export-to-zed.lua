-- Export active buffers to Zed
-- https://github.com/kogakure/export-to-zed.nvim
return {
	"kogakure/export-to-zed.nvim",
	lazy = false,
	keys = {
		{ "<leader>zed", "<CMD>ExportToZed<CR>", desc = "Export to Zed" },
	},
	config = function()
		require("export-to-zed").setup()
	end,
}

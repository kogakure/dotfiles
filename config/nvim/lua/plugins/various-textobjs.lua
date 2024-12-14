return {
	"chrisgrieser/nvim-various-textobjs",
	config = function()
		require("various-textobjs").setup({
			keymaps = {
				useDefaults = true,
			},
		})
	end,
}

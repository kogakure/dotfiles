--
local status, ssr = pcall(require, "ssr")
if not status then
	return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

ssr.setup({
	min_width = 50,
	min_height = 5,
	keymaps = {
		close = "q",
		next_match = "n",
		prev_match = "N",
		replace_all = "<leader><cr>",
	},
})

-- Keymaps
keymap({ "n", "x" }, "<leader>sr", function()
	require("ssr").open()
end, opts)

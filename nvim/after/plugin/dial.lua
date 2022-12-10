-- https://github.com/karb94/neoscroll.nvim
local status, augend = pcall(require, "dial.augend")
if not status then
	return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

require("dial.config").augends:register_group({
	default = {
		augend.constant.alias.bool,
		augend.constant.alias.de_weekday,
		augend.constant.alias.de_weekday_full,
		augend.date.alias["%d.%m.%Y"],
		augend.hexcolor.new({ case = "lower" }),
		augend.integer.alias.decimal_int,
		augend.semver.alias.semver,
	},
})

-- Keymaps
keymap("n", "<C-a>", require("dial.map").inc_normal(), opts)
keymap("n", "<C-x>", require("dial.map").dec_normal(), opts)
keymap("v", "<C-a>", require("dial.map").inc_visual(), opts)
keymap("v", "<C-x>", require("dial.map").dec_visual(), opts)
keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), opts)
keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), opts)

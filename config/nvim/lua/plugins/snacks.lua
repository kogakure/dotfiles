-- 🍿 A collection of QoL plugins for Neovim
-- https://github.com/folke/snacks.nvim/tree/main
return {
	"folke/snacks.nvim",
	opts = {
		dashboard = {
			formats = {
				header = { "%s", hl = "String", align = "center" },
				icon = { "%s", hl = "String" },
			},
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "p", desc = "Find Project", action = ":Telescope projects" },
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
					{ icon = " ", key = "e", desc = "LazyExtras", action = ":LazyExtras" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = "󱊈 ", key = "m", desc = "Mason", action = ":Mason" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				header = [[
			         ▖
			┌─╮╭─╮╭─╮▖  ▖▖▄▄▗▄
			│ │├─┘│ │▝▖▞ ▌▌ ▌ ▌
			╵ ╵╰─╯╰─╯ ▝  ▘▘ ▘ ▘
			]],
			},
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}

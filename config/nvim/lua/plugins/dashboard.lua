return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	opts = function()
		local logo = "\n"
			.. "         ▖\n"
			.. "┌─╮╭─╮╭─╮▖  ▖▖▄▄▗▄ \n"
			.. "│ │├─┘│ │▝▖▞ ▌▌ ▌ ▌\n"
			.. "╵ ╵╰─╯╰─╯ ▝  ▘▘ ▘ ▘\n"
			.. "\n"

		logo = string.rep("\n", 5) .. logo .. "\n\n"

		local opts = {
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
				header = vim.split(logo, "\n"),
				center = {
					{
						action = "FzfLua files",
						desc = " Find file",
						icon = " ",
						key = "f",
					},
					{
						action = "ene | startinsert",
						desc = " New file",
						icon = " ",
						key = "n",
					},
					{
						action = "FzfLua oldfiles",
						desc = " Recent files",
						icon = " ",
						key = "r",
					},
					{
						action = "FzfLua live_grep",
						desc = " Find text",
						icon = " ",
						key = "g",
					},
					{
						action = "Telescope projects",
						desc = " Find project",
						icon = " ",
						key = "p",
					},
					{
						action = 'lua require("persistence").load()',
						desc = " Restore Session",
						icon = " ",
						key = "s",
					},
					{
						action = "LazyExtras",
						desc = " Lazy Extras",
						icon = " ",
						key = "e",
					},
					{
						action = "Lazy",
						desc = " Lazy",
						icon = "󰒲 ",
						key = "l",
					},
					{
						action = "Mason",
						desc = " Mason",
						icon = "󱊈 ",
						key = "m",
					},
					{
						action = "qa",
						desc = " Quit",
						icon = " ",
						key = "q",
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {
						"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
					}
				end,
			},
		}

		for _, button in ipairs(opts.config.center) do
			button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
		end

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "DashboardLoaded",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		return opts
	end,
}

local colors = {
	white = "#ffffff",
	blue = "#88A1BB",
	green = "#b7d670",
	magenta = "#a889d2",
	orange = "#fd9f4d",
	yellow = "#f3fa9b",
	transparent = "None",
}

return {
	normal = {
		a = { bg = colors.transparent, fg = colors.blue, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	insert = {
		a = { bg = colors.transparent, fg = colors.green, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	visual = {
		a = { bg = colors.transparent, fg = colors.magenta, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	replace = {
		a = { bg = colors.transparent, fg = colors.orange, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	command = {
		a = { bg = colors.transparent, fg = colors.yellow, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
	inactive = {
		a = { bg = colors.transparent, fg = colors.white, gui = "bold" },
		b = { bg = colors.transparent, fg = colors.white },
		c = { bg = colors.transparent, fg = colors.white },
	},
}

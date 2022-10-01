-- Zen Mode – https://github.com/folke/zen-mode.nvim
local status_ok, zenmode = pcall(require, "zen-mode")
if not status_ok then
	return
end

zenmode.setup({
	window = {
		backdrop = 0.98,
		width = 80,
		height = 0.85,
		options = {
			signcolumn = "no", -- disable signcolumn
			number = false, -- disable number column
			relativenumber = false, -- disable relative numbers
			cursorline = false, -- disable cursorline
			cursorcolumn = false, -- disable cursor column
			foldcolumn = "0", -- disable fold column
			list = false, -- disable whitespace characters
		},
	},
	plugins = {
		options = {
			enabled = true,
			ruler = true, -- disables the ruler text in the cmd line area
			showcmd = false, -- disables the command in the last line of the screen
		},
		twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
		gitsigns = { enabled = false }, -- disables git signs
		tmux = { enabled = true }, -- disables the tmux statusline
		kitty = {
			enabled = true,
			font = "+5", -- font size increment
		},
	},
	on_open = function()
		vim.cmd([[:IndentBlanklineDisable]])
	end,
	on_close = function()
		vim.cmd([[:IndentBlanklineEnable]])
	end,
})

-- Improved fzf.vim written in lua
-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ ";R", "<cmd>FzfLua oldfiles<cr>", desc = "Recently used" },
		{ ";a", "<cmd>FzfLua files --hidden<cr>", desc = "Find Files (hidden)" },
		{ ";b", "<cmd>FzfLua buffers previewer=false path_shorten=true winopts.height=0.4 winopts.width=0.6 winopts.row=0.4<cr>", desc = "Buffers" },
		{ ";cs", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell Suggest" },
		{ ";d", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
		{ ";f", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ ";r", "<cmd>FzfLua resume<cr>", desc = "Resume" },
		{ "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ "<C-t>", "<cmd>FzfLua<cr>", desc = "Telescope" },
		{ "<M-p>", "<cmd>FzfLua files --hidden<cr>", desc = "Find Files (hidden)" },
	},
	opts = {},
}

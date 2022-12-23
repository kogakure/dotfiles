-- https://github.com/is0n/fm-nvim
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<M-g>", "<CMD>Lazygit<CR>", opts)
vim.keymap.set("n", "<M-l>", "<CMD>Lf<CR>", opts)
vim.keymap.set("n", "<leader>lf", "<CMD>Lf<CR>", opts)
vim.keymap.set("n", "<leader>lg", "<CMD>Lazygit<CR>", opts)

require("fm-nvim").setup({
	edit_cmd = "edit",
	on_close = {},
	on_open = {},
	ui = {
		default = "float",
		float = {
			border = "rounded",
			float_hl = "Normal",
			border_hl = "FloatBorder",
			blend = 0,
			height = 0.9,
			width = 0.9,
			x = 0.5,
			y = 0.5,
		},
		split = {
			direction = "topleft",
			size = 24,
		},
	},
	cmds = {
		lf_cmd = "lf",
		fm_cmd = "fm",
		nnn_cmd = "nnn",
		fff_cmd = "fff",
		twf_cmd = "twf",
		fzf_cmd = "fzf",
		fzy_cmd = "find . | fzy",
		xplr_cmd = "xplr",
		vifm_cmd = "vifm",
		skim_cmd = "sk",
		broot_cmd = "broot",
		gitui_cmd = "gitui",
		ranger_cmd = "ranger",
		joshuto_cmd = "joshuto",
		lazygit_cmd = "lazygit",
		neomutt_cmd = "neomutt",
		taskwarrior_cmd = "taskwarrior-tui",
	},
	mappings = {
		vert_split = "<C-v>",
		horz_split = "<C-h>",
		tabedit = "<C-t>",
		edit = "<C-e>",
		ESC = "<ESC>",
	},
})

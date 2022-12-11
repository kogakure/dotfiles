-- https://github.com/akinsho/toggleterm.nvim
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<C-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = {
		noremap = true,
	}
	local keymap = vim.api.nvim_buf_set_keymap

	keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
})

local ranger = Terminal:new({
	cmd = "ranger",
	hidden = true,
})

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

function _RANGER_TOGGLE()
	ranger:toggle()
end

local tig = Terminal:new({
	cmd = "tig",
	hidden = true,
})

function _TIG_TOGGLE()
	tig:toggle()
end

local node = Terminal:new({
	cmd = "node",
	hidden = true,
})

function _NODE_TOGGLE()
	node:toggle()
end

local ncdu = Terminal:new({
	cmd = "ncdu",
	hidden = true,
})

function _NCDU_TOGGLE()
	ncdu:toggle()
end

local htop = Terminal:new({
	cmd = "htop",
	hidden = true,
})

function _HTOP_TOGGLE()
	htop:toggle()
end

local python = Terminal:new({
	cmd = "python",
	hidden = true,
})

function _PYTHON_TOGGLE()
	python:toggle()
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Keymaps
keymap("n", "<M-g>", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<M-o>", "<cmd>lua _RANGER_TOGGLE()<CR>", opts)
keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>ncdu", "<cmd>lua _NCDU_TOGGLE()<CR>", opts)
keymap("n", "<leader>node", "<cmd>lua _NODE_TOGGLE()<CR>", opts)
keymap("n", "<leader>rg", "<cmd>lua _RANGER_TOGGLE()<CR>", opts)
keymap("n", "<leader>top", "<cmd>lua _HTOP_TOGGLE()<CR>", opts)
keymap("n", "<leader>y", "<cmd>lua _PYTHON_TOGGLE()<CR>", opts)

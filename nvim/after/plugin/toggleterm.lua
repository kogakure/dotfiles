-- https://github.com/akinsho/toggleterm.nvim
local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal
local opts = { noremap = true, silent = true }

-- Keymaps
vim.keymap.set("n", "<leader>ncdu", "<cmd>lua _NCDU_TOGGLE()<CR>", opts)
vim.keymap.set("n", "<leader>node", "<cmd>lua _NODE_TOGGLE()<CR>", opts)
vim.keymap.set("n", "<leader>top", "<cmd>lua _HTOP_TOGGLE()<CR>", opts)
vim.keymap.set("n", "<leader>y", "<cmd>lua _PYTHON_TOGGLE()<CR>", opts)

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

local tig = Terminal:new({ cmd = "tig", hidden = true })
local node = Terminal:new({ cmd = "node", hidden = true })
local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
local htop = Terminal:new({ cmd = "htop", hidden = true })
local python = Terminal:new({ cmd = "python", hidden = true })

function _TIG_TOGGLE()
	tig:toggle()
end

function _NODE_TOGGLE()
	node:toggle()
end

function _NCDU_TOGGLE()
	ncdu:toggle()
end

function _HTOP_TOGGLE()
	htop:toggle()
end

function _PYTHON_TOGGLE()
	python:toggle()
end

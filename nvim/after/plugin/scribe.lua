-- scribe.nvim – https://github.com/Ostralyan/scribe.nvim
local status_ok, scribe = pcall(require, "scribe")
if not status_ok then
	return
end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

scribe.setup({
	directory = "~/Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/Notes/",
	file_ext = "md",
	default_file = "scratch",
})

-- Keymaps
keymap("n", "<leader>sc", [[<Cmd>ScribeOpen<CR>]], opts)
keymap("n", "<leader>so", [[:ScribeOpen<space>]], opts)
keymap("n", "<leader>sf", [[<Cmd>ScribeFind<CR>]], opts)

-- Harpoon – https://github.com/ThePrimeagen/harpoon
local status, harpoon = pcall(require, "harpoon")
if not status then
	return
end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

harpoon.setup()

-- Keymaps
keymap("n", "<leader>a", [[<Cmd>lua require("harpoon.mark").add_file()<CR>]], opts)
keymap("n", "<leader>,", [[<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], opts)
keymap("n", "<leader>1", [[<Cmd>lua require("harpoon.ui").nav_file(1)<CR>]], opts)
keymap("n", "<leader>2", [[<Cmd>lua require("harpoon.ui").nav_file(2)<CR>]], opts)
keymap("n", "<leader>3", [[<Cmd>lua require("harpoon.ui").nav_file(3)<CR>]], opts)
keymap("n", "<leader>4", [[<Cmd>lua require("harpoon.ui").nav_file(4)<CR>]], opts)

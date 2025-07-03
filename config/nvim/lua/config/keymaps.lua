-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
rawset(_G, "vim", vim or {})

vim.keymap.set("n", "<leader>j", ":b#<CR>", { desc = "Toggle between buffers", noremap = true, silent = true })
vim.keymap.set("n", ";;", "A;<ESC>", { desc = "Add semicolon to the end of the line", noremap = true, silent = true })
vim.keymap.set("n", ",,", "A,<ESC>", { desc = "Add comma to the end of the line", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("v", "y", "myy`y", { desc = "Maintain the cursor position when yanking a visual selection", noremap = true, silent = true })
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true, silent = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bx", ":bufdo bdelete<CR>", { desc = "Delete all buffers", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding buffers" })
vim.keymap.set("n", "<leader>ut", ":set list!<CR>", { desc = "Toggle list", noremap = true, silent = true })
vim.keymap.set("n", "Y", "yg$", { desc = "Copy to the end of the line", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep the window centered (next search result)", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep the window centered (previous search result)", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("n", "<expr> j", "(v:count == 0 ? 'gj' : 'j')", { desc = "Move by rows in wrapped mode (down)", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("n", "<expr> k", "(v:count == 0 ? 'gk' : 'k')", { desc = "Move by rows in wrapped mode (up)", noremap = true, silent = true })
-- stylua: ignore
vim.keymap.set("n", "<leader>wi", ":silent !open -a iA\\ Writer.app '%:p'<CR>", { desc = "Open in iA Writer", noremap = true, silent = true })

vim.keymap.set("n", "-", "<CMD>foldclose<CR>", { desc = "Close code fold" })
vim.keymap.set("n", "+", "<CMD>foldopen<CR>", { desc = "Open code fold" })

vim.keymap.set("n", "<C-h>", function()
	require("smart-splits").move_cursor_left()
end)
vim.keymap.set("n", "<C-j>", function()
	require("smart-splits").move_cursor_down()
end)
vim.keymap.set("n", "<C-k>", function()
	require("smart-splits").move_cursor_up()
end)
vim.keymap.set("n", "<C-l>", function()
	require("smart-splits").move_cursor_right()
end)

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Visual Mode
vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode (left)", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode (right)", noremap = true, silent = true })

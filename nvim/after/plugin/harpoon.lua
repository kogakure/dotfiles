-- https://github.com/ThePrimeagen/harpoon
local harpoon = require("harpoon")
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>a", [[<Cmd>lua require("harpoon.mark").add_file()<CR>]], opts)
vim.keymap.set("n", "<leader>,", [[<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], opts)
vim.keymap.set("n", "<leader>1", [[<Cmd>lua require("harpoon.ui").nav_file(1)<CR>]], opts)
vim.keymap.set("n", "<leader>2", [[<Cmd>lua require("harpoon.ui").nav_file(2)<CR>]], opts)
vim.keymap.set("n", "<leader>3", [[<Cmd>lua require("harpoon.ui").nav_file(3)<CR>]], opts)
vim.keymap.set("n", "<leader>4", [[<Cmd>lua require("harpoon.ui").nav_file(4)<CR>]], opts)

harpoon.setup()

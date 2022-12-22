vim.keymap.set("", "<space>", "<Nop>", { desc = "Remap space as leader key", noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>j", ":b#<CR>", { desc = "Quick toggle between buffers", noremap = true, silent = true })

vim.keymap.set("n", ";;", "A;<ESC>", { desc = "Add semicolon to the end of the line", noremap = true, silent = true })
vim.keymap.set("n", ",,", "A,<ESC>", { desc = "Add comma to the end of the line", noremap = true, silent = true })

vim.keymap.set("v", "y", "myy`y", { desc = "Maintain the cursor position when yanking a visual selection", noremap = true, silent = true })

vim.keymap.set("n", "<leader>x", "$x", { desc = "Delete last character of line", noremap = true, silent = true })
vim.keymap.set("n", "x", '"_x', { desc = "Do not yank with x", noremap = true, silent = true })

vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true, silent = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true, silent = true })

vim.keymap.set("n", "ss", ":split<CR><C-w>w", { desc = "Open horizontal split", noremap = true, silent = true })
vim.keymap.set("n", "sv", ":vsplit<CR><C-w>w", { desc = "Open vertical split", noremap = true, silent = true })

vim.keymap.set("n", "<leader>q", ":Bdelete<CR>", { desc = "Delete current buffer", noremap = true, silent = true })
vim.keymap.set("n", "<leader>X", ":bufdo bdelete<CR>", { desc = "Delete all buffers", noremap = true, silent = true })

vim.keymap.set("", "gf", ":edit <cfile><CR>", { desc = "Allow gf to open non-existent files", noremap = true, silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Reselect visual selection after indenting left", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Reselect visual selection after indenting right", noremap = true, silent = true })

-- zg (good), zG (good temp), zw (wrong), zW (wrong temp)
vim.keymap.set("n", "<leader>rs", ":set spell!<CR>", { desc = "Activate spell checking", noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Switch off highlighting", noremap = true, silent = true })
vim.keymap.set("n", "<leader>l", ":set list!<CR>", { desc = "Toggle list", noremap = true, silent = true })

vim.keymap.set("n", "<leader>pf", "gg=G''", { desc = "Indent the whole source code", noremap = true, silent = true })

vim.keymap.set("n", "'", "`", { desc = "Reverse the mark mapping", noremap = true, silent = true })
vim.keymap.set("n", "`", "'", { desc = "Reverse the mark mapping", noremap = true, silent = true })

vim.keymap.set("n", "gP", "`[v`]", { desc = "Visuall select of just pasted content", noremap = true, silent = true })
vim.keymap.set("n", "gy", "`[v`]y", { desc = "Visuall select of just pasted content", noremap = true, silent = true })

vim.keymap.set("n", "<expr> j", "(v:count == 0 ? 'gj' : 'j')", { desc = "Move by rows in wrapped mode (down)", noremap = true, silent = true })
vim.keymap.set("n", "<expr> k", "(v:count == 0 ? 'gk' : 'k')", { desc = "Move by rows in wrapped mode (up)", noremap = true, silent = true })

vim.keymap.set("n", "<leader>?", ":execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>", { desc = "Open a quickfix window for the last search", noremap = true, silent = true })

vim.keymap.set("n", "<C-e>", "3<C-e>", { desc = "Faster linewise scrolling (up)", noremap = true, silent = true })
vim.keymap.set("n", "<C-y>", "3<C-y>", { desc = "Faster linewise scrolling (down)", noremap = true, silent = true })

vim.keymap.set("n", "G", "Gzzzv", { desc = "Keep the window centered (end)", noremap = true, silent = true })
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep the window centered (next search result)", noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep the window centered (previous search result)", noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep the window centered (page down)", noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep the window centered (page up)", noremap = true, silent = true })

vim.keymap.set("n", "Y", "yg$", { desc = "Copy to the end of the line", noremap = true, silent = true })

vim.keymap.set("n", "XX", ":qa<CR>", { desc = "Close all buffers", noremap = true, silent = true })

vim.keymap.set("n", "gN", "o<ESC>k", { desc = "Add lines in NORMAL Mode (below)", noremap = true, silent = true })
vim.keymap.set("n", "gNN", "O<ESC>j", { desc = "Add lines in NORMAL Mode (above)", noremap = true, silent = true })

vim.keymap.set("n", "<leader>cf", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change to the folder of the current file", noremap = true, silent = true })

vim.keymap.set("n", "<leader>rq", "gqip", { desc = "Reformat a line into a block", noremap = true, silent = true })

vim.keymap.set("n", "<leader>rqq", "vipJ", { desc = "Reformat a block into a line", noremap = true, silent = true })

vim.keymap.set("n", "<C-J>", "<C-W><C-K>", { desc = "Easier split navigation (down)", noremap = true, silent = true })
vim.keymap.set("n", "<C-K>", "<C-W><C-L>", { desc = "Easier split navigation (up)", noremap = true, silent = true })
vim.keymap.set("n", "<C-L>", "<C-W><C-H>", { desc = "Easier split navigation (right)", noremap = true, silent = true })
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", { desc = "Easier split navigation (left)", noremap = true, silent = true })

vim.keymap.set("n", "<leader>kw", ":SmartResizeMode<CR>", { desc = "Activate Smart Resize Mode", noremap = true, silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode (left)", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode (right)", noremap = true, silent = true })

vim.keymap.set("v", "<S-k>", ":m .-2<CR>==", { desc = "Move text up", noremap = true, silent = true })
vim.keymap.set("v", "<S-j>", ":m .+1<CR>==", { desc = "Move text down", noremap = true, silent = true })

vim.keymap.set("n", "<leader>ia", ":silent !open -a iA\\ Writer.app '%:p'<CR>", { desc = "Open in iA Writer", noremap = true, silent = true })

vim.keymap.set("n", "<leader>o", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format buffer with LSP", noremap = true, silent = true })
vim.keymap.set("n", "<leader>P", "<cmd>Prettier<CR>", { desc = "Format with Prettier", noremap = true, silent = true })

vim.keymap.set("n", "<leader>kn", ":let @+=@%<CR>", { desc = "Get the filename and path of current file", noremap = true, silent = true })
vim.keymap.set("n", "<leader>kc", ":g/console.log/d<CR>", { desc = "Remove console.log statements", noremap = true, silent = true })
vim.keymap.set("v", "<leader>kp", ":'<,'> w !pandoc --no-highlight --wrap=none | pbcopy <CR>", { desc = "Convert Markdown to HTML and copy to Clipboard", noremap = true, silent = true })

vim.keymap.set("n", "gsii", "<CMD>lua Select_indent()<CR>:sort<CR>", { desc = "Sort lines by indentation", noremap = true, silent = true })

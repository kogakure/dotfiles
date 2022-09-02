local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--- Remap space as <leader> key
keymap("", "<space>", "<Nop>", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick toggle between buffers
keymap("n", "<leader>j", ":b#<CR>", opts)

-- Add semicolon or comma to the end of the line
keymap("n", ";;", "A;<ESC>", opts)
keymap("n", ",,", "A,<ESC>", opts)

-- Maintain the cursor position when yanking a visual selection
keymap("v", "y", "myy`y", opts)

-- Delete last character of line
keymap("n", "<leader>x", "$x", opts)

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- Open vim config in a new buffer, reload vim config
keymap("n", "<leader>ve", "<cmd>e $MYVIMRC<CR>", opts)
keymap("n", "<leader>vr", "<cmd>source $MYVIMRC<CR>", opts)

-- Increment/decrement
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

-- Splits
keymap("n", "ss", ":split<CR><C-w>w", opts)
keymap("n", "sv", ":vsplit<CR><C-w>w", opts)

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Delete current buffer
keymap("n", "<leader>q", ":Bdelete<CR>", opts)

-- Delete all buffers
keymap("n", "<leader>X", ":bufdo bdelete<CR>", opts)

-- Allow gf to open non-existent files
keymap("", "gf", ":edit <cfile><CR>", opts)

-- Reselect visual selection after indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Set spell checker to `s`
-- zg (good), zG (good temp), zw (wrong), zW (wrong temp)
keymap("n", "<leader>rs", ":set spell!<CR>", opts)

-- Switch off highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Toggle list
keymap("n", "<leader>l", ":set list!<CR>", opts)

-- Indent the whole source code
keymap("n", "<leader>pf", "gg=G''", opts)

-- Reverse the mark mapping
keymap("n", "'", "`", opts)
keymap("n", "`", "'", opts)

-- Visuall select of just pasted content
keymap("n", "gP", "`[v`]", opts)
keymap("n", "gy", "`[v`]y", opts)

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
keymap("n", "<expr> j", "(v:count == 0 ? 'gj' : 'j')", opts)
keymap("n", "<expr> k", "(v:count == 0 ? 'gk' : 'k')", opts)

-- Open a quickfix window for the last search
keymap("n", "<leader>?", ":execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>", opts)

-- Faster linewise scrolling
keymap("n", "<C-e>", "3<C-e>", opts)
keymap("n", "<C-y>", "3<C-y>", opts)

-- Keep the window centered
keymap("n", "G", "Gzzzv", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Copy to the end of the line
keymap("n", "Y", "yg$", opts)

-- Close all buffers
keymap("n", "XX", ":qa<CR>", opts)

-- Add lines in NORMAL Mode
keymap("n", "gN", "o<ESC>k", opts)
keymap("n", "gNN", "O<ESC>j", opts)

-- Change to the folder of the current file
keymap("n", "<leader>cf", ":cd %:p:h<CR>:pwd<CR>", opts)

-- Reformat a line into a block
keymap("n", "<leader>rq", "gqip", opts)

-- Reformat a block into a line
keymap("n", "<leader>rqq", "vipJ", opts)

-- Easier split navigation
keymap("n", "<C-J>", "<C-W><C-K>", opts)
keymap("n", "<C-K>", "<C-W><C-L>", opts)
keymap("n", "<C-L>", "<C-W><C-H>", opts)
keymap("n", "<C-H>", "<C-W><C-H>", opts)

-- Resize with arrows
keymap("n", "<C-M-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-M-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-M-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-M-Right>", ":vertical resize -2<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Remap Jump to Tag
keymap("n", "ü", "<C-]>", opts)
keymap("n", "Ü", "<C-O>", opts)

-- Open for Markdown in iA Writer
keymap("n", "<leader>ia", ":silent !open -a iA\\ Writer.app '%:p'<CR>", opts)

-- Custom Text-Objects
keymap("o", "il", ":<c-u>normal! $v^<CR>", opts)
keymap("x", "il", ":<c-u>normal! $v^<CR>", opts)
keymap("o", "al", ":<c-u>normal! $v0<CR>", opts)
keymap("x", "al", ":<c-u>normal! $v0<CR>", opts)

-- LSP formatting
keymap("n", "<leader>o", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)

local opts = { noremap = true, silent = true }

--- Remap space as <leader> key
vim.keymap.set("", "<space>", "<Nop>", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick toggle between buffers
vim.keymap.set("n", "<leader>j", ":b#<CR>", opts)

-- Add semicolon or comma to the end of the line
vim.keymap.set("n", ";;", "A;<ESC>", opts)
vim.keymap.set("n", ",,", "A,<ESC>", opts)

-- Maintain the cursor position when yanking a visual selection
vim.keymap.set("v", "y", "myy`y", opts)

-- Delete last character of line
vim.keymap.set("n", "<leader>x", "$x", opts)

-- Do not yank with x
vim.keymap.set("n", "x", '"_x', opts)

-- Open vim config in a new buffer, reload vim config
vim.keymap.set("n", "<leader>ve", "<cmd>e $MYVIMRC<CR>", opts)
vim.keymap.set("n", "<leader>vr", "<cmd>source $MYVIMRC<CR>", opts)

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>", opts)
vim.keymap.set("n", "-", "<C-x>", opts)

-- Splits
vim.keymap.set("n", "ss", ":split<CR><C-w>w", opts)
vim.keymap.set("n", "sv", ":vsplit<CR><C-w>w", opts)

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Delete current buffer
vim.keymap.set("n", "<leader>q", ":Bdelete<CR>", opts)

-- Delete all buffers
vim.keymap.set("n", "<leader>X", ":bufdo bdelete<CR>", opts)

-- Allow gf to open non-existent files
vim.keymap.set("", "gf", ":edit <cfile><CR>", opts)

-- Reselect visual selection after indenting
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Set spell checker to `s`
-- zg (good), zG (good temp), zw (wrong), zW (wrong temp)
vim.keymap.set("n", "<leader>rs", ":set spell!<CR>", opts)

-- Switch off highlighting
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Toggle list
vim.keymap.set("n", "<leader>l", ":set list!<CR>", opts)

-- Indent the whole source code
vim.keymap.set("n", "<leader>pf", "gg=G''", opts)

-- Reverse the mark mapping
vim.keymap.set("n", "'", "`", opts)
vim.keymap.set("n", "`", "'", opts)

-- Visuall select of just pasted content
vim.keymap.set("n", "gP", "`[v`]", opts)
vim.keymap.set("n", "gy", "`[v`]y", opts)

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
vim.keymap.set("n", "<expr> j", "(v:count == 0 ? 'gj' : 'j')", opts)
vim.keymap.set("n", "<expr> k", "(v:count == 0 ? 'gk' : 'k')", opts)

-- Open a quickfix window for the last search
vim.keymap.set("n", "<leader>?", ":execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>", opts)

-- Faster linewise scrolling
vim.keymap.set("n", "<C-e>", "3<C-e>", opts)
vim.keymap.set("n", "<C-y>", "3<C-y>", opts)

-- Keep the window centered
vim.keymap.set("n", "G", "Gzzzv", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Copy to the end of the line
vim.keymap.set("n", "Y", "yg$", opts)

-- Close all buffers
vim.keymap.set("n", "XX", ":qa<CR>", opts)

-- Add lines in NORMAL Mode
vim.keymap.set("n", "gN", "o<ESC>k", opts)
vim.keymap.set("n", "gNN", "O<ESC>j", opts)

-- Change to the folder of the current file
vim.keymap.set("n", "<leader>cf", ":cd %:p:h<CR>:pwd<CR>", opts)

-- Reformat a line into a block
vim.keymap.set("n", "<leader>rq", "gqip", opts)

-- Reformat a block into a line
vim.keymap.set("n", "<leader>rqq", "vipJ", opts)

-- Easier split navigation
vim.keymap.set("n", "<C-J>", "<C-W><C-K>", opts)
vim.keymap.set("n", "<C-K>", "<C-W><C-L>", opts)
vim.keymap.set("n", "<C-L>", "<C-W><C-H>", opts)
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-M-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-M-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-M-Left>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-M-Right>", ":vertical resize -2<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)

-- Navigate buffers
--[[ vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts) ]]
--[[ vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts) ]]

-- Remap Jump to Tag
vim.keymap.set("n", "ü", "<C-]>", opts)
vim.keymap.set("n", "Ü", "<C-O>", opts)

-- Open for Markdown in iA Writer
vim.keymap.set("n", "<leader>ia", ":silent !open -a iA\\ Writer.app '%:p'<CR>", opts)

-- Custom Text-Objects
vim.keymap.set("o", "il", ":<c-u>normal! $v^<CR>", opts)
vim.keymap.set("x", "il", ":<c-u>normal! $v^<CR>", opts)
vim.keymap.set("o", "al", ":<c-u>normal! $v0<CR>", opts)
vim.keymap.set("x", "al", ":<c-u>normal! $v0<CR>", opts)

-- LSP formatting
vim.keymap.set("n", "<leader>o", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

-- Manual Prettier
vim.keymap.set("n", "<leader>P", "<cmd>Prettier<CR>", opts)

-- Get the filename and path of current file
vim.keymap.set("n", "<leader>kn", ":let @+=@%<CR>", opts)

-- Remove console.log statements
vim.keymap.set("n", "<leader>kc", ":g/console.log/d<CR>", opts)

-- Convert Markdown to HTML and copy to Clipboard
vim.keymap.set("v", "<leader>kp", ":'<,'> w !pandoc --no-highlight --wrap=none | pbcopy <CR>", opts)

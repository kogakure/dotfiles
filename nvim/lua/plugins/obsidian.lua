-- Obsidian
-- https://github.com/epwalsh/obsidian.nvim
return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Zettelkasten/**.md",
  },
  dependencies = {
    -- required
    "nvim-lua/plenary.nvim",
    -- optional
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "junegunn/fzf",
    "junegunn/fzf.vim",
    "godlygeek/tabular",
    "preservim/vim-markdown",
  },
  opts = {
    dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Zettelkasten", -- no need to call 'vim.fn.expand' here
  },
}

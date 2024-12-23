-- Lf file manager for Neovim
-- https://github.com/lmburns/lf.nvim
return {
  "lmburns/lf.nvim",
  cmd = "Lf",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim",
  },
  keys = {
    { "<leader>fl", "<cmd>Lf<cr>", desc = "Lf File Manager" },
  },
  opts = {
    winblend = 0,
    highlights = { NormalFloat = { guibg = "NONE" } },
    border = "curved",
    escape_quit = true,
  },
}

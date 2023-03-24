-- Lf file manager for Neovim
-- https://github.com/lmburns/lf.nvim
return {
  "lmburns/lf.nvim",
  cmd = "Lf",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim",
  },
  cond = vim.g.vscode == nil,
  keys = {
    { "<leader>fl", "<cmd>Lf<cr>", desc = "Lf File Manager" },
  },
  opts = {
    winblend = 0,
    highlights = { NormalFloat = { guibg = "NONE" } },
    border = "curved",
    height = 0.70,
    width = 0.85,
    escape_quit = true,
  },
}

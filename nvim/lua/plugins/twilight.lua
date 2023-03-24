-- Distraction-free coding
-- https://github.com/folke/zen-mode.nvim
return {
  "folke/twilight.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    require("twilight").setup()
  end,
}

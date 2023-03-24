-- Switch between hard and soft wrapping
-- https://github.com/andrewferrier/wrapping.nvim
return {
  "andrewferrier/wrapping.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    require("wrapping").setup()
  end,
}

-- A tree view for symbols
-- https://github.com/simrat39/symbols-outline.nvim
return {
  "simrat39/symbols-outline.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    require("symbols-outline").setup({
      width = 25,
    })
  end,
}

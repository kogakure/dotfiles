-- A tree view for symbols
-- https://github.com/simrat39/symbols-outline.nvim
return {
  "simrat39/symbols-outline.nvim",
  config = function()
    require("symbols-outline").setup({
      width = 25,
    })
  end,
}

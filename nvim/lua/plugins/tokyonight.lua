--  https://github.com/folke/tokyonight.nvim
return {
  "folke/tokyonight.nvim",
  lazy = true,
  cond = vim.g.vscode == nil,
  opts = { style = "night" },
}

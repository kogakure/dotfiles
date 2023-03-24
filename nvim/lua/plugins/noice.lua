-- Experimental UI plugin
-- https://github.com/folke/noice.nvim
return {
  "folke/noice.nvim",
  cond = vim.g.vscode == nil,
  opts = {
    lsp = {
      progress = {
        enabled = true,
      },
    },
  },
}

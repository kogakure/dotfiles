-- Minimap
-- https://github.com/gorbit99/codewindow.nvim
return {
  "gorbit99/codewindow.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    local codewindow = require("codewindow")
    codewindow.setup()
    codewindow.apply_default_keybinds()
  end,
}

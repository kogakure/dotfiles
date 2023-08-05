-- Minimap
-- https://github.com/gorbit99/codewindow.nvim
return {
  "gorbit99/codewindow.nvim",
  config = function()
    local codewindow = require("codewindow")
    codewindow.setup({
      window_border = "none",
    })
    codewindow.apply_default_keybinds()
  end,
}

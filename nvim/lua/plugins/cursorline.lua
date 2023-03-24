-- Highlight cursor words and lines
-- https://github.com/yamatsum/nvim-cursorline
return {
  "yamatsum/nvim-cursorline",
  cond = vim.g.vscode == nil,
  config = function()
    require("nvim-cursorline").setup({
      cursorline = {
        enable = true,
        timeout = 1000,
        number = false,
      },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    })
  end,
}

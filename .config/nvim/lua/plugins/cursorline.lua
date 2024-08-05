-- Highlight cursor words and lines
-- https://github.com/yamatsum/nvim-cursorline
return {
  "yamatsum/nvim-cursorline",
  config = function()
    require("nvim-cursorline").setup({
      cursorline = {
        enable = false,
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

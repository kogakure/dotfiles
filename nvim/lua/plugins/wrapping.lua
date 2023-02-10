-- Switch between hard and soft wrapping
-- https://github.com/andrewferrier/wrapping.nvim
return {
  "andrewferrier/wrapping.nvim",
  config = function()
    require("wrapping").setup()
  end,
}

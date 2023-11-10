-- barbecue.nvim
-- https://github.com/utilyre/barbecue.nvim
return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbecue").setup()
    require("barbecue.ui").toggle(true)
  end,
}

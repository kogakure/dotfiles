return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>-", "<CMD>lua require('oil').open()<CR>", desc = "Oil" },
  },
  config = function()
    require("oil").setup()
  end,
}

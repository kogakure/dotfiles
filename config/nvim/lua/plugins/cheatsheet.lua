-- Searchable Cheatsheet
-- https://github.com/sudormrfbin/cheatsheet.nvim
return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>C", "<cmd>Cheatsheet<cr>", desc = "Cheatsheet" },
  },
  config = function()
    require("cheatsheet").setup()
  end,
}

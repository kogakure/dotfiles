-- Neovim plugin for fast file-finding
-- https://github.com/danielfalk/smart-open.nvim
return {
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  keys = {
    { ";o", "<cmd>Telescope smart_open<cr>", desc = "Smart Open" },
  },
  config = function()
    require("telescope").load_extension("smart_open")
  end,
  dependencies = {
    "kkharji/sqlite.lua",
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
}

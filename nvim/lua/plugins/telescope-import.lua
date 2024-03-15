-- Import modules with ease
-- https://github.com/piersolenski/telescope-import.nvim
return {
  "piersolenski/telescope-import.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  keys = {
    { ";i", "<cmd>Telescope import<cr>", desc = "Import Modules" },
  },
  config = function()
    require("telescope").load_extension("import")
  end,
}

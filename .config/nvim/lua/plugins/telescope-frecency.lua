-- Telescope extensionn that offers intelligent priorization
-- https://github.com/nvim-telescope/telescope-frecency.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    keys = {
      { ";mr", "<cmd>Telescope frecency<cr>", desc = "Most recently used files" },
    },
    opts = {
      extensions = {
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          disable_devicons = false,
        },
      },
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
}

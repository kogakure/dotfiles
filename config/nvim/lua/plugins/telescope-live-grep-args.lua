-- Telescope extension to search with arguments
-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-live-grep-args.nvim",
    opts = {
      extensions = {
        live_grep_args = {
          auto_quoting = true,
        },
      },
    },
    keys = {
      { ";s", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
}

-- Telescope extension to search with arguments
-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-live-grep-args.nvim",
    cond = vim.g.vscode == nil,
    opts = {
      extensions = {
        live_grep_args = {
          auto_quoting = true,
        },
      },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
}

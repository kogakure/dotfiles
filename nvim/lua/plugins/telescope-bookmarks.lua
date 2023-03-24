-- Telescope extension to open your Browser bookmarks
-- https://github.com/dhruvmanila/telescope-bookmarks.nvim
return {
  "telescope.nvim",
  dependencies = {
    "dhruvmanila/telescope-bookmarks.nvim",
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>sR", "<cmd>Telescope bookmarks<cr>", desc = "Brave Bookmarks" },
    },
    opts = {
      extensions = {
        bookmarks = {
          selected_browser = "brave",
          url_open_command = "open",
        },
      },
    },
    config = function()
      require("telescope").load_extension("bookmarks")
    end,
  },
}

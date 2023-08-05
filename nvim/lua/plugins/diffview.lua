-- Easily cycle through diffs
-- https://github.com/sindrets/diffview.nvim
return {
  "sindrets/diffview.nvim",
  lazy = false,
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>gdx", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
  },
  opts = {
    view = {
      use_icons = true,
      default = {
        layout = "diff2_horizontal",
        winbar_info = false,
      },
    },
  },
}

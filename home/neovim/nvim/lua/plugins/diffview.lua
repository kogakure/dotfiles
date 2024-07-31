-- Easily cycle through diffs
-- https://github.com/sindrets/diffview.nvim
return {
  "sindrets/diffview.nvim",
  lazy = false,
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
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

-- Telescope extension to view and search the undo tree
-- https://github.com/debugloop/telescope-undo.nvim
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
  },
  cond = vim.g.vscode == nil,
  opts = {
    extensions = {
      undo = {
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.8,
        },
      },
    },
  },
  config = function()
    require("telescope").load_extension("undo")
  end,
}

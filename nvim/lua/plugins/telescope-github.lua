-- Telescope extension to integrate with GitHub CLI
-- https://github.com/nvim-telescope/telescope-github.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-github.nvim",
    cond = vim.g.vscode == nil,
    config = function()
      require("telescope").load_extension("gh")
    end,
  },
}

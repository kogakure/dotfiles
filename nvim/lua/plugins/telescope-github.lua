-- Telescope extension to integrate with GitHub CLI
-- https://github.com/nvim-telescope/telescope-github.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-github.nvim",
    keys = {
      { ";p", "<cmd>Telescope gh pull_request<cr>", desc = "GitHub Pull Requests" },
    },
    config = function()
      require("telescope").load_extension("gh")
    end,
  },
}

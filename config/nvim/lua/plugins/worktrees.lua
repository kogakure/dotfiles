return {
  "Juksuu/worktrees.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "telescope.nvim",
  },
  keys = {
    {
      ";w",
      function()
        require("telescope").extensions.worktrees.list_worktrees()
      end,
      desc = "Telescope Git Worktrees",
    },
  },
  config = function()
    require("worktrees").setup()
    require("telescope").load_extension("worktrees")
  end,
}

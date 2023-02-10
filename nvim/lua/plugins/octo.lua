-- Edit and review GitHub issues and pull requests
-- https://github.com/pwntester/octo.nvim
return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup()
  end,
}

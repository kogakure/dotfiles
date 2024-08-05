-- An interactive and powerful Git interface for Neovim
-- https://github.com/NeogitOrg/neogit
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>gn",
      function()
        require("neogit").open()
      end,
      desc = "Neogit",
    },
  },
  config = true,
}

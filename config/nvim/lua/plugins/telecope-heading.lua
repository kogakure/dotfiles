-- Telescope extention to switch between Headlines
-- https://github.com/crispgm/telescope-heading.nvim
return {
  "telescope.nvim",
  dependencies = {
    "crispgm/telescope-heading.nvim",
    keys = {
      { ";h", "<cmd>Telescope heading<cr>", desc = "Headlines" },
    },
    opts = {
      extensions = {
        heading = {
          treesitter = true,
        },
      },
    },
    config = function()
      require("telescope").load_extension("heading")
    end,
  },
}

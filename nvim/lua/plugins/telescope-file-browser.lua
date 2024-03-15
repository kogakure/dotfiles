-- Telescope extension for a File Browser
-- https://github.com/nvim-telescope/telescope-file-browser.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
      {
        ";t",
        "<cmd>Telescope file_browser respect_gitignore=false hidden=true grouped=true<cr>",
        desc = "File Browser",
      },
    },
    opts = {
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
      },
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
}

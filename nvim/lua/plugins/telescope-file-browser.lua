-- Telescope extension for a File Browser
-- https://github.com/nvim-telescope/telescope-file-browser.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-file-browser.nvim",
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>sB", ":Telescope file_browser path=%:p:h=%:p:h<cr>", desc = "Browse Files" },
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

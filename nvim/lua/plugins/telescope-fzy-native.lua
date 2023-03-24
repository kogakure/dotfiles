-- Telescope extension for a FZY style sorter that is compiled
-- https://github.com/nvim-telescope/telescope-fzy-native.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzy-native.nvim",
    cond = vim.g.vscode == nil,
    opts = {
      extensions = {
        fzy_native = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    config = function()
      require("telescope").load_extension("fzy_native")
    end,
  },
}

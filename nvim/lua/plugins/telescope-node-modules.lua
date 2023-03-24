-- Telescope plugin to search the node_modules directory
-- https://github.com/nvim-telescope/telescope-node-modules.nvim
return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-node-modules.nvim",
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>sN", "<cmd>Telescope node_modules list<cr>", desc = "Node Modules" },
    },
    config = function()
      require("telescope").load_extension("node_modules")
    end,
  },
}

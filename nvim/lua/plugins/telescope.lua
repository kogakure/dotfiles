-- Find, Filter, Preview, Pick
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "telescope.nvim",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<C-t>", "<cmd>Telescope<cr>", desc = "Telescope" },
    { "<M-b>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<M-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { "<leader>sg", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep" },
    { "<leader>tr", "<cmd>Telescope resume<cr>", desc = "Telescope" },
    { "<leader>tu", "<cmd>Telescope undo<cr>", desc = "Undo Tree" },
  },
}

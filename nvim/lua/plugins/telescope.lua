-- Find, Filter, Preview, Pick
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "telescope.nvim",
  keys = {
    { ";a", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { ";b", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { ";cs", "<cmd>Telescope spell_suggest<cr>", desc = "Spell Suggest" },
    { ";d", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { ";f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { ";n", "<cmd>Telescope notify<cr>", desc = "Notify" },
    { ";r", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<C-t>", "<cmd>Telescope<cr>", desc = "Telescope" },
    { "<M-b>", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { "<M-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { "\\\\", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
  },
}

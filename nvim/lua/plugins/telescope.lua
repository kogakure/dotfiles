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
    { ";mr", "<cmd>Telescope frecency<cr>", desc = "Most recently used files" },
    { ";n", "<cmd>Telescope notify<cr>", desc = "Notify" },
    { ";r", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { ";s", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep" },
    {
      ";t",
      "<cmd>Telescope file_browser respect_gitignore=false hidden=true grouped=true<cr>",
      desc = "File Browser",
    },
    { ";u", "<cmd>Telescope undo<cr>", desc = "Undo Tree" },
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<C-t>", "<cmd>Telescope<cr>", desc = "Telescope" },
    { "<M-b>", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { "<M-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { "\\\\", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
  },
}

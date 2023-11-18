-- Find, Filter, Preview, Pick
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "telescope.nvim",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<C-t>", "<cmd>Telescope<cr>", desc = "Telescope" },
    { "<M-b>", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { "<M-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { "\\\\", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { ";b", "<cmd>Telescope buffers previewer=false shorten_path=true theme=dropdown<cr>", desc = "Buffers" },
    { ";ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { ";s", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep" },
    { ";r", "<cmd>Telescope resume<cr>", desc = "Resume" },
    {
      ";t",
      "<cmd>Telescope file_browser initial_mode='normal' respect_gitignore=false hidden=true grouped=true<cr>",
      desc = "File Browser",
    },
    { ";e", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { ";u", "<cmd>Telescope undo<cr>", desc = "Undo Tree" },
    { ";mr", "<cmd>Telescope frecency<cr>", desc = "Most recently used files" },
  },
}

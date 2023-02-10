-- Getting you where you want with the fewest keystrokes
-- https://github.com/ThePrimeagen/harpoon
return {
  "ThePrimeagen/harpoon",
  dependencies = "nvim-telescope/telescope.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>a", function() require("harpoon.ui").add_file() end, desc = "Harpoon Add File" },
    { "<leader>;", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Toggle Quickmenu" },
    { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon Buffer 1" },
    { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon Buffer 2" },
    { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon Buffer 3" },
    { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon Buffer 4" },
  },
  opts = {
    global_settings = {
      mark_branch = true,
    },
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  config = function()
    require("harpoon").setup()
    require("telescope").load_extension("harpoon")
  end,
}

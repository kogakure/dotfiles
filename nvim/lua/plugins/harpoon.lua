-- Getting you where you want with the fewest keystrokes
-- https://github.com/ThePrimeagen/harpoon
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():append()
      end,
      desc = "Harpoon Add File",
    },
    {
      "<leader>;",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon Quickmenu",
    },
    {
      "<leader>1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon Buffer 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon Buffer 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon Buffer 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon Buffer 4",
    },
    {
      "<leader>5",
      function()
        require("harpoon"):list():select(5)
      end,
      desc = "Harpoon Buffer 5",
    },
  },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
}

return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    { "<leader>wr", "<cmd>SmartResizeMode<cr>", desc = "Toggle Smart Resize Mode" },
  },
  config = function()
    require("smart-splits").setup({
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
      },
      ignored_buftypes = { "NvimTree" },
      default_amount = 3,
      wrap_at_edge = true,
      move_cursor_same_row = false,
      resize_mode = {
        quit_key = "<ESC>",
        resize_keys = { "h", "j", "k", "l" },
        silent = false,
        hooks = {
          on_enter = nil,
          on_leave = nil,
        },
      },
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      tmux_integration = true,
      disable_tmux_nav_when_zoomed = true,
    })
  end,
}

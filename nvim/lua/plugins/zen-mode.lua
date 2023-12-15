-- Distraction-free coding
-- https://github.com/folke/zen-mode.nvim
return {
  "folke/zen-mode.nvim",
  keys = {
	-- stylua: ignore
    { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  config = function()
    require("zen-mode").setup({
      window = {
        backdrop = 0.98,
        width = 80,
        height = 0.85,
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = true, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        kitty = {
          enabled = true,
          font = "+2", -- font size increment
        },
      },
    })
  end,
}

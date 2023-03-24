-- Show Git blame inline
-- https://github.com/APZelos/blamer.nvim
return {
  "APZelos/blamer.nvim",
  cond = vim.g.vscode == nil,
  keys = {
	-- stylua: ignore
    { "<leader>gB", "<cmd>BlamerToggle<cr>", desc = "Git Blame" },
  },
  config = function()
    vim.g.blamer_enabled = 0
    vim.g.blamer_relative_time = 1
    vim.g.blamer_delay = 200
  end,
}

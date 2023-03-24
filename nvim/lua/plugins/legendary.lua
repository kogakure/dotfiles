-- A legend for your keymaps, commands, and autocmds
-- https://github.com/mrjones2014/legendary.nvim
return {
  "mrjones2014/legendary.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  cond = vim.g.vscode == nil,
  keys = {
	-- stylua: ignore
    { "<leader>L", "<cmd>Legendary<cr>", desc = "Legendary" },
  },
  config = function()
    require("legendary").setup({
      which_key = { auto_register = true },
    })
  end,
}

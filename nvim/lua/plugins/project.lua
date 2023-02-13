-- The superior project management solution for neovim
-- https://github.com/ahmedkhalf/project.nvim
return {
  "ahmedkhalf/project.nvim",
  lazy = false,
  keys = {
	-- stylua: ignore
    { "<leader>p", ":Telescope projects<cr>", desc = "Search Projects" },
  },
  config = function()
    require("project_nvim").setup({
      active = true,
      on_config_done = nil,
      manual_mode = false,
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", ".gitignore", "package.json", "!node_modules" },
      show_hidden = false,
      silent_chdir = true,
      ignore_lsp = {},
      datapath = vim.fn.stdpath("data"),
    })
    require("telescope").load_extension("projects")
  end,
}

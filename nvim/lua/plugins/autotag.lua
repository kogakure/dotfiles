-- Use treesitter to auto close and auto rename HTML tags
-- https://github.com/windwp/nvim-ts-autotag
return {
  "windwp/nvim-ts-autotag",
  cond = vim.g.vscode == nil,
  config = function()
    require("nvim-ts-autotag").setup({
      disable_filetype = { "TelescopePrompt", "vim" },
    })
  end,
}

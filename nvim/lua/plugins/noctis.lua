--  https://github.com/kartikp10/noctis.nvim
return {
  {
    "kartikp10/noctis.nvim",
    dependencies = "rktjmp/lush.nvim",
    cond = vim.g.vscode == nil,
  }, -- Noctis color scheme
}

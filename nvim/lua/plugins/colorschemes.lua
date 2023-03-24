-- Configure LazyVim to load Tokyo Night
return {
  {
    "LazyVim/LazyVim",
    cond = vim.g.vscode == nil,
    opts = {
      colorscheme = "tokyonight",
    },
  },
}

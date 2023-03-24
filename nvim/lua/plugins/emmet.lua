-- Emmet
-- https://github.com/mattn/emmet-vim
-- <c-y>, to extend
return {
  "mattn/emmet-vim",
  cond = vim.g.vscode == nil,
}

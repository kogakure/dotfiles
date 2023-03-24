-- Seamless navigation between tmux panes and vim splits
-- https://github.com/christoomey/vim-tmux-navigator
return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  cond = vim.g.vscode == nil,
}

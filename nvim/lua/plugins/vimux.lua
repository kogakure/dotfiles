-- Easily interact with tmux from vim
-- https://github.com/preservim/vimux
return {
  "preservim/vimux",
  cond = vim.g.vscode == nil,
  config = function()
    vim.g.VimuxHeight = "30"
    vim.g.VimuxOrientation = "h"
    vim.g.VimuxUseNearestPane = 0
  end,
}

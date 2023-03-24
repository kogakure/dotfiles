-- Track time and metrics
-- https://github.com/wakatime/vim-wakatime
return {
  "wakatime/vim-wakatime",
  event = "VeryLazy",
  cond = vim.g.vscode == nil,
}

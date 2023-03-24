-- A fancy, configurable notification manager
-- https://github.com/rcarriga/nvim-notify
return {
  "rcarriga/nvim-notify",
  cond = vim.g.vscode == nil,
  opts = {
    render = "minimal",
    stages = "static",
    timeout = 2000,
  },
}

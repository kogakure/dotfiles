-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Custom Highlight
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1F2334" })
vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#A8CD76" })
vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#A8CD76" })
vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#A8CD76" })

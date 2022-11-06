-- https://github.com/github/copilot.vim
local status_ok = pcall(require, "copilot")
if not status_ok then
	return
end

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

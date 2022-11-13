-- https://github.com/gorbit99/codewindow.nvim
local status, codewindow = pcall(require, "codewindow")
if not status then
	return
end

codewindow.setup()

-- <leader>mo - open the minimap
-- <leader>mc - close the minimap
-- <leader>mf - focus/unfocus the minimap
-- <leader>mm - toggle the minimap
codewindow.apply_default_keybinds()

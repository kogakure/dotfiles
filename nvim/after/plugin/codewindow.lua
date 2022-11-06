-- https://github.com/gorbit99/codewindow.nvim
local status, codewindow = pcall(require, "codewindow")
if not status then
	return
end

codewindow.setup()
codewindow.apply_default_keybinds()

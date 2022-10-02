-- Octo.nvim – https://github.com/pwntester/octo.nvim
local status_ok, octo = pcall(require, "octo")
if not status_ok then
	return
end

octo.setup()

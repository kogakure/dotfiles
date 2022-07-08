-- nvim-spectre – https://github.com/nvim-pack/nvim-spectre
local status_ok, spectre = pcall(require, "spectre")
if not status_ok then
	return
end

spectre.setup()

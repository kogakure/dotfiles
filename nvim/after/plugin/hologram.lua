-- Hologram – https://github.com/edluffy/hologram.nvim
local status, hologram = pcall(require, "hologram")
if not status then
	return
end

hologram.setup({
	auto_display = true,
})

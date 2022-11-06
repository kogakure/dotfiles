-- https://github.com/catppuccin/catppuccin
local status_ok, catppucin = pcall(require, "catppuccin")
if not status_ok then
	return
end

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

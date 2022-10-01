-- sad.nvim – https://github.com/ray-x/sad.nvim
local status_ok, sad = pcall(require, "sad")
if not status_ok then
	return
end

sad.setup({
	diff = "delta", -- you can use `diff`, `diff-so-fancy`
	ls_file = "fd", -- also git ls_file
	exact = false, -- exact match
	vsplit = true, -- split sad window the screen vertically, when set to number
	height_ratio = 0.6, -- height ratio of sad window when split horizontally
	width_ratio = 0.6, -- height ratio of sad window when split vertically
})

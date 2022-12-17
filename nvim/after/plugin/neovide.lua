-- https://github.com/neovide/neovide
if vim.fn.exists("g:neovide") then
	vim.o.guifont = "FiraCode Nerd Font:h20"

	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
end

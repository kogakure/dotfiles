-- Colorschemes

-- Base16 Theme
local source = "~/.vimrc_background"
local status_ok, _ = pcall(vim.cmd, "source " .. source)

if not status_ok then
	vim.notify("Error sourcing " .. source)
	return
end

vim.cmd([[
silent! colorscheme tokyonight-night
highlight ColorColumn guibg=#202224
highlight SpellBad guifg=red
]])

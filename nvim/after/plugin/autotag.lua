-- nvim-ts-autotag – https://github.com/windwp/nvim-ts-autotag
local status_ok, autotag = pcall(require, "nvim-ts-autotag")
if not status_ok then
	return
end

autotag.setup({
	disable_filetype = { "TelescopePrompt", "vim" },
})

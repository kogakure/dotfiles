-- nvim-lightbulb – https://github.com/kosayoda/nvim-lightbulb
local status, lightbulb = pcall(require, "nvim-lightbulb")
if not status then
	return
end

lightbulb.setup({
	autocmd = {
		enabled = true
	},
})

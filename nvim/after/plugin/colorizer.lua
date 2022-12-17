-- https://github.com/norcalli/nvim-colorizer.lua
require("colorizer").setup({
	"css",
	"html",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
}, {
	RGB = true,
	RRGGBB = true,
	names = true,
	RRGGBBAA = true,
	rgb_fn = true,
	hsl_fn = true,
	css = true,
	css_fn = true,
	mode = "background",
})

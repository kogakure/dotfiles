-- https://github.com/goolord/alpha-nvim
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find Files", ":Telescope find_files<CR>"),
	dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
	dashboard.button("p", "  Find Project", ":Telescope projects<CR>"),
	dashboard.button("r", "  Recently Used Files", ":Telescope oldfiles<CR>"),
	dashboard.button("t", "  Find Text", ":Telescope grep_string<CR>"),
	dashboard.button("b", "  Browser Bookmarks", ":Telescope bookmarks<CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("u", "  Update Plugins", ":Lazy sync<CR>"),
	dashboard.button("m", "  Mason (LSP, DAP, Linter, Formatter)", ":Mason<CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)

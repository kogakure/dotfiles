-- alpha-nvim – https://github.com/goolord/alpha-nvim
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	[[🟨🟨🟨🟨🟨🟨🟨🟨]],
	[[🟨🟨🟨🟨🟨🟨🟨🟨]],
	[[🟨🟨🟨 🐍 🟨🟨🟨]],
	[[🟨🟨🌿🌿🌿🌿🟨🟨]],
	[[🟨🟨🟨🟨🟨🟨🟨🟨]],
	[[DONT TREAD ON ME]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find Files", ":FzfLua files<CR>"),
	dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
	dashboard.button("p", "  Find Project", ":Telescope projects<CR>"),
	dashboard.button("r", "  Recently Used Files", ":FzfLua oldfiles<CR>"),
	dashboard.button("t", "  Find Text", ":FzfLua live_grep<CR>"),
	dashboard.button("b", "  Browser Bookmarks", ":Telescope bookmarks<CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("u", "  Update Plugins", ":PackerUpdate<CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Colorscheme and font
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 22.0
config.line_height = 1.1
config.color_scheme = "Tokyo Night"

config.cursor_blink_rate = 0
config.audible_bell = "Disabled"

-- Tokyo Night color scheme (custom adjustments)
config.colors = {
	cursor_bg = "#f8f8f0",
	cursor_fg = "#000000",
	selection_bg = "#373b41",
	selection_fg = "#ffffff",
	ansi = { "#1f1f1f", "#f92672", "#a6e22e", "#fd971f", "#66d9ef", "#ae81ff", "#a1efe4", "#f8f8f2" },
	brights = { "#75715e", "#f92672", "#a6e22e", "#fd971f", "#66d9ef", "#ae81ff", "#a1efe4", "#f9f8f5" },
}

config.front_end = "WebGpu"

-- Window
config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.window_background_opacity = 0.70
config.initial_cols = 100
config.initial_rows = 65
config.enable_tab_bar = false
config.macos_window_background_blur = 30
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 30,
	right = 30,
	top = 30,
	bottom = 30,
}

-- Custom Keybindings
config.keys = {
	{ key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
	{ key = ",", mods = "CTRL|CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "i", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2i" }) },
	{ key = "d", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2d" }) },
	{ key = "z", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2z" }) },
	{ key = "t", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2c" }) },
	{ key = "f", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2O" }) },
	{ key = ",", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2v" }) },
	{ key = "g", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2G" }) },
	{ key = "D", mods = "CTRL|ALT|SHIFT", action = wezterm.action({ SendString = "\2D" }) },
	{ key = "s", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2f" }) },
	{ key = "j", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2s" }) },
	{ key = "k", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2s" }) },
	{ key = "1", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\21" }) },
	{ key = "2", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\22" }) },
	{ key = "3", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\23" }) },
	{ key = "4", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\24" }) },
	{ key = "5", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\25" }) },
	{ key = "6", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\26" }) },
	{ key = "7", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\27" }) },
	{ key = "8", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\28" }) },
	{ key = "9", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\29" }) },
	{ key = "r", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2R" }) },
	{ key = "[", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2p" }) },
	{ key = "h", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2p" }) },
	{ key = "]", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2n" }) },
	{ key = "l", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2n" }) },
	{ key = "n", mods = "CTRL|ALT|SHIFT", action = wezterm.action({ SendString = '\2"' }) },
	{ key = "%", mods = "CTRL|ALT|SHIFT", action = wezterm.action({ SendString = "\2%" }) },
	{ key = "q", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2d" }) },
	{ key = ";", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2:" }) },
	{ key = "y", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2!" }) },
	{ key = "w", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2x" }) },
}

return config

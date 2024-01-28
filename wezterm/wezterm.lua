local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Colorscheme and font
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("Monaspace Radon")
-- config.font = wezterm.font("Monaspace Neon")
config.font = wezterm.font({
	family = "Monaspace Neon",
	harfbuzz_features = {
		"calt=1",
		"clig=1",
		"liga=1",
		"dlig=1",
		"ss01=1",
		"ss02=1",
		"ss03=1",
		"ss04=1",
		"ss05=1",
		"ss06=1",
		"ss07=1",
		"ss08=1",
	},
})
config.font_size = 22.0
config.line_height = 1.2
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
config.window_background_opacity = 0.85
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
	{ key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen }, -- Toggle fullscreen
	{ key = ",", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2v" }) }, -- Rename window
	{ key = "1", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\21" }) }, -- window 1
	{ key = "2", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\22" }) }, -- window 2
	{ key = "3", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\23" }) }, -- window 3
	{ key = "4", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\24" }) }, -- window 4
	{ key = "5", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\25" }) }, -- window 5
	{ key = "6", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\26" }) }, -- window 6
	{ key = "7", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\27" }) }, -- window 7
	{ key = "8", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\28" }) }, -- window 8
	{ key = "9", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\29" }) }, -- window 9
	{ key = ";", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2:" }) }, -- Command Mode
	{ key = "D", mods = "CTRL|ALT|SHIFT", action = wezterm.action({ SendString = "\2D" }) }, -- Lazydocker
	{ key = "[", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2p" }) }, -- Previous window
	{ key = "]", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2n" }) }, -- Next window
	{ key = "d", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2d" }) }, -- Detach session
	{ key = "f", mods = "CTRL|ALT", action = wezterm.action({ SendString = ":Grep\n" }) }, -- Telescope Live Grep
	{ key = "g", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2G" }) }, -- Lazygit
	{ key = "h", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2p" }) }, -- Previous window
	{ key = "i", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2i" }) }, -- Cht.sh
	{ key = "j", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2s" }) }, -- Select windows
	{ key = "k", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2s" }) }, -- Select windows
	{ key = "l", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2n" }) }, -- Next window
	{ key = "p", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2\84" }) }, -- Smart tmux session manager
	{ key = "q", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2d" }) }, -- Detach session
	{ key = "r", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2R" }) }, -- Return to last session
	{ key = "t", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2c" }) }, -- New window
	{ key = "w", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2x" }) }, -- Close window
	{ key = "y", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2!" }) }, -- Move pane to new window
	{ key = "z", mods = "CTRL|ALT", action = wezterm.action({ SendString = "\2z" }) }, -- Zoom into window
}

return config

require("functions")
require("caffeine")

rawset(_G, "hs", hs or {})

local application = hs.application
local window = hs.window
local layout = hs.layout
local screen = hs.screen
local hotkey = hs.hotkey
local hints = hs.hints

-------------------
-- Configuration --
-------------------

-- Animation
window.animationDuration = 0

-- Hints
hints.fontName = "Helvetica-Bold"
hints.fontSize = 18
hints.showTitleThresh = 0
hints.style = "vimperator"

-- Allow searching for alternate names
application.enableSpotlightForNameSearches(true)

------------
-- Aliases --
------------

-- Keys
local KEY_HYPER = { "⇧", "⌃", "⌥", "⌘" }
local KEY_A = { "⌥" }
local KEY_AM = { "⌥", "⌘" }
local KEY_CA = { "⌃", "⌥" }
local KEY_CAM = { "⌃", "⌥", "⌘" }
local KEY_CM = { "⌃", "⌘" }
local KEY_SA = { "⇧", "⌥" }
local KEY_SAM = { "⇧", "⌥", "⌘" }
local KEY_SC = { "⇧", "⌘" }
local KEY_SCA = { "⇧", "⌃", "⌥" }
local KEY_SCM = { "⇧", "⌃", "⌘" }

-- Displays
local DISPLAY_PRIMARY = screen.primaryScreen()
local DISPLAY_NOTEBOOK = "Color LCD"

-- Sizes
local LEFT_MOST = hs.geometry.unitrect(0, 0, 0.6, 1)
local LEFT_LESS = hs.geometry.unitrect(0, 0, 0.4, 1)
local RIGHT_MOST = hs.geometry.unitrect(0.4, 0, 0.6, 1)
local RIGHT_LESS = hs.geometry.unitrect(0.6, 0, 0.4, 1)
local FULLSCREEN = hs.geometry.unitrect(0, 0, 1, 1)
local RIGHT_HALF = hs.geometry.unitrect(0.5, 0, 0.5, 1)
local LEFT_HALF = hs.geometry.unitrect(0, 0, 0.5, 1)

-------------
-- Layouts --
-------------

-- Format reminder:
-- {"App name", "Window name", "Display Name", "unitrect", "framerect", "fullframerect"},

-- One Monitor and Notebook
local LAYOUT_DUAL = {
	{ "Brave Browser", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Calendar", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Code", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "DEVONthink 3", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Element", nil, DISPLAY_NOTEBOOK, RIGHT_HALF, nil, nil },
	{ "Firefox Developer Edition", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Mail", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Messages", nil, DISPLAY_PRIMARY, RIGHT_HALF, nil, nil },
	{ "Microsoft Outlook", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Music", nil, DISPLAY_NOTEBOOK, FULLSCREEN, nil, nil },
	{ "Obsidian", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Slack", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Sonos", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Telegram", nil, DISPLAY_PRIMARY, LEFT_HALF, nil, nil },
	{ "Things", nil, DISPLAY_NOTEBOOK, FULLSCREEN, nil, nil },
	{ "iA Writer", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "kitty", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
}

--  One Monitor
local LAYOUT_SINGLE = {
	{ "Brave Browser", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Calendar", nil, DISPLAY_PRIMARY, LEFT_MOST, nil, nil },
	{ "Code", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "DEVONthink 3", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Element", nil, DISPLAY_PRIMARY, RIGHT_HALF, nil, nil },
	{ "Firefox Developer Edition", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Mail", nil, DISPLAY_PRIMARY, RIGHT_MOST, nil, nil },
	{ "Messages", nil, DISPLAY_PRIMARY, RIGHT_LESS, nil, nil },
	{ "Microsoft Outlook", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Music", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Obsidian", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Slack", nil, DISPLAY_PRIMARY, LEFT_MOST, nil, nil },
	{ "Sonos", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "Telegram", nil, DISPLAY_PRIMARY, LEFT_MOST, nil, nil },
	{ "Things", nil, DISPLAY_PRIMARY, RIGHT_LESS, nil, nil },
	{ "iA Writer", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
	{ "kitty", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil },
}

------------------
-- Key Bindings --
------------------

-- stylua: ignore start

-- Movement hotkeys
-- hotkey.bind(KEY_AM, "down",  function() Nudge(0, 100) end)
-- hotkey.bind(KEY_AM, "up",    function() Nudge(0, -100) end)
-- hotkey.bind(KEY_AM, "right", function() Nudge(100, 0) end)
-- hotkey.bind(KEY_AM, "left",  function() Nudge(-100, 0) end)

-- Resize hotkeys
-- hotkey.bind(KEY_SAM, "up",    function() Yank(0, -100) end)
-- hotkey.bind(KEY_SAM, "down",  function() Yank(0, 100) end)
-- hotkey.bind(KEY_SAM, "right", function() Yank(100, 0) end)
-- hotkey.bind(KEY_SAM, "left",  function() Yank(-100, 0) end)

-- Push to screen edge
-- hotkey.bind(KEY_CAM, "left",  function() Push(0, 0, 0.5, 1) end)
-- hotkey.bind(KEY_CAM, "right", function() Push(0.5, 0, 0.5, 1) end)
-- hotkey.bind(KEY_CAM, "up",    function() Push(0, 0, 1, 0.5) end)
-- hotkey.bind(KEY_CAM, "down",  function() Push(0, 0.5, 1, 0.5) end)

-- Focus
-- hotkey.bind(KEY_CAM, 'k', function() window.focusedWindow():focusWindowNorth() end)
-- hotkey.bind(KEY_CAM, 'j', function() window.focusedWindow():focusWindowSouth() end)
-- hotkey.bind(KEY_CAM, 'l', function() window.focusedWindow():focusWindowEast() end)
-- hotkey.bind(KEY_CAM, 'h', function() window.focusedWindow():focusWindowWest() end)


-- Centered window with some room to see the desktop
-- hotkey.bind(KEY_SCM, "l", function() Push(0.05, 0.05, 0.9, 0.9) end)
-- hotkey.bind(KEY_SCM, "m", function() Push(0.1, 0.1, 0.8, 0.8) end)
-- hotkey.bind(KEY_SCM, "s", function() Push(0.15, 0.15, 0.7, 0.7) end)

-- Fullscreen
-- hotkey.bind(KEY_CAM, "0", function() Push(0, 0, 1, 1) end)

-- Quarter Screens
-- hotkey.bind(KEY_CAM, "q", function() Push(0, 0, 0.5, 0.5) end)
-- hotkey.bind(KEY_CAM, "w", function() Push(0.5, 0, 0.5, 0.5) end)
-- hotkey.bind(KEY_CAM, "a", function() Push(0, 0.5, 0.5, 0.5) end)
-- hotkey.bind(KEY_CAM, "s", function() Push(0.5, 0.5, 0.5, 0.5) end)

-- Part Screens
-- hotkey.bind(KEY_CAM, "4", function() Push(0, 0, 0.6, 1) end)
-- hotkey.bind(KEY_CAM, "5", function() Push(0, 0, 0.4, 1) end)
-- hotkey.bind(KEY_CAM, "6", function() Push(0.4, 0, 0.6, 1) end)
-- hotkey.bind(KEY_CAM, "7", function() Push(0.6, 0, 0.4, 1) end)

-- Move a window between monitors (preserve size)
-- hotkey.bind(KEY_CM,  "1",     function() window.focusedWindow():moveOneScreenNorth() end)
-- hotkey.bind(KEY_CM,  "2",     function() window.focusedWindow():moveOneScreenSouth() end)
-- hotkey.bind(KEY_CM,  "3",     function() window.focusedWindow():moveOneScreenWest() end)
-- hotkey.bind(KEY_CM,  "down",  function() window.focusedWindow():moveOneScreenSouth() end)
-- hotkey.bind(KEY_CM,  "h",     function() window.focusedWindow():moveOneScreenWest() end)
-- hotkey.bind(KEY_CM,  "j",     function() window.focusedWindow():moveOneScreenSouth() end)
-- hotkey.bind(KEY_CM,  "k",     function() window.focusedWindow():moveOneScreenNorth() end)
-- hotkey.bind(KEY_CM,  "l",     function() window.focusedWindow():moveOneScreenEast() end)
-- hotkey.bind(KEY_CM,  "left",  function() window.focusedWindow():moveOneScreenWest() end)
-- hotkey.bind(KEY_CM,  "right", function() window.focusedWindow():moveOneScreenEast() end)
-- hotkey.bind(KEY_CM,  "up",    function() window.focusedWindow():moveOneScreenNorth() end)

-- Move a window between monitors (change to fullscreen)
-- hotkey.bind(KEY_SCM, "1",     function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "2",     function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "3",     function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "up",    function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "down",  function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "right", function() window.focusedWindow():moveOneScreenEast(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "left",  function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "k",     function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "j",     function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "l",     function() window.focusedWindow():moveOneScreenEast(); push(0, 0, 1, 1) end)
-- hotkey.bind(KEY_SCM, "h",     function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)

-- Yabai
-- Focus Window
hotkey.bind(KEY_A, "h", function() Yabai({"window --focus west"}) end)
hotkey.bind(KEY_A, "j", function() Yabai({"window --focus south"}) end)
hotkey.bind(KEY_A, "k", function() Yabai({"window --focus north"}) end)
hotkey.bind(KEY_A, "l", function() Yabai({"window --focus east"}) end)

-- Swap Managed Windows
hotkey.bind(KEY_SA, "h", function() Yabai({"window --swap west"}) end)
hotkey.bind(KEY_SA, "j", function() Yabai({"window --swap south"}) end)
hotkey.bind(KEY_SA, "k", function() Yabai({"window --swap north"}) end)
hotkey.bind(KEY_SA, "l", function() Yabai({"window --swap east"}) end)

-- Move Managed Windows
hotkey.bind(KEY_SCA, "h", function() Yabai({"window --warp west"}) end)
hotkey.bind(KEY_SCA, "j", function() Yabai({"window --warp south"}) end)
hotkey.bind(KEY_SCA, "k", function() Yabai({"window --warp north"}) end)
hotkey.bind(KEY_SCA, "l", function() Yabai({"window --warp east"}) end)

-- Rotate Windows
hotkey.bind(KEY_A, "r", function() Yabai({"space --rotate 90"}) end)

-- Toggle Window Fullscreen Zoom
hotkey.bind(KEY_A, "f", function() Yabai({"window --toggle zoom-fullscreen"}) end)

-- Toggle Padding and Gap
hotkey.bind(KEY_A, "g", function() Yabai({"space --toggle padding", "space --toggle gap"}) end)

-- Float/Unfloat Window
hotkey.bind(KEY_A, "t", function() Yabai({"window --toggle float", "window --grid 7:7:1:1:5:5"}) end)

-- Toggle Window Split Type
hotkey.bind(KEY_A, "e", function() Yabai({"window --toggle split"}) end)

-- Balance Size of Windows
hotkey.bind(KEY_SA, "0", function() Yabai({"space --balance"}) end)

-- Move Window to space
hotkey.bind(KEY_SCA, "1", function() Yabai({"window --space 1"}) end)
hotkey.bind(KEY_SCA, "2", function() Yabai({"window --space 2"}) end)
hotkey.bind(KEY_SCA, "3", function() Yabai({"window --space 3"}) end)
hotkey.bind(KEY_SCA, "4", function() Yabai({"window --space 4"}) end)
hotkey.bind(KEY_SCA, "5", function() Yabai({"window --space 5"}) end)
hotkey.bind(KEY_SCA, "6", function() Yabai({"window --space 6"}) end)
hotkey.bind(KEY_SCA, "7", function() Yabai({"window --space 7"}) end)
hotkey.bind(KEY_SCA, "8", function() Yabai({"window --space 8"}) end)
hotkey.bind(KEY_SCA, "9", function() Yabai({"window --space 9"}) end)

-- Send Window to Monitor
hotkey.bind(KEY_SA, "n", function() Yabai({"window --display next"}) end)
hotkey.bind(KEY_SA, "p", function() Yabai({"window --display prev"}) end)

-- Move Focus to Monitor
hotkey.bind(KEY_SAM, "h", function() Yabai({"display --focus next"}) end)
hotkey.bind(KEY_SAM, "l", function() Yabai({"display --focus prev"}) end)

-- Application shortcuts
hotkey.bind(KEY_SC,    "r", function() launchToggleApplication("Wezterm") end)
hotkey.bind(KEY_SC,    "w", function() launchToggleApplication("kitty") end)
hotkey.bind(KEY_HYPER, "a", function() launchToggleApplication("Arc") end)
hotkey.bind(KEY_HYPER, "b", function() launchToggleApplication("Brave Browser") end)
hotkey.bind(KEY_HYPER, "c", function() launchToggleApplication("Visual Studio Code") end)
hotkey.bind(KEY_HYPER, "d", function() launchToggleApplication("DEVONthink 3") end)
hotkey.bind(KEY_HYPER, "e", function() launchToggleApplication("Eagle") end)
hotkey.bind(KEY_HYPER, "f", function() launchToggleApplication("Reeder") end)
hotkey.bind(KEY_HYPER, "g", function() launchToggleApplication("Signal") end)
hotkey.bind(KEY_HYPER, "i", function() launchToggleApplication("Messages") end)
hotkey.bind(KEY_HYPER, "m", function() launchToggleApplication("Mail") end)
hotkey.bind(KEY_HYPER, "n", function() launchToggleApplication("MindNode") end)
hotkey.bind(KEY_HYPER, "o", function() launchToggleApplication("Obsidian") end)
hotkey.bind(KEY_HYPER, "r", function() launchToggleApplication("Raindrop.io") end)
hotkey.bind(KEY_HYPER, "s", function() launchToggleApplication("Spotify") end)
hotkey.bind(KEY_HYPER, "t", function() launchToggleApplication("Things") end)
hotkey.bind(KEY_HYPER, "u", function() launchToggleApplication("Kalender") end)
hotkey.bind(KEY_HYPER, "w", function() launchToggleApplication("iA Writer") end)
hotkey.bind(KEY_HYPER, "x", function() launchToggleApplication("Microsoft Teams") end)

-- Place red circle around mouse
hotkey.bind(KEY_CAM, "space", MouseHighlight)

-- Hints
hotkey.bind(KEY_HYPER, "space", function() hints.windowHints(GetAllValidWindows()) end)

-- Manual config reloading (from getting started guide):
hotkey.bind(KEY_HYPER, "delete", function() hs.reload() end)

-- Layouts
hotkey.bind(KEY_HYPER, "1", function() layout.apply(LAYOUT_SINGLE) end)
hotkey.bind(KEY_HYPER, "2", function() layout.apply(LAYOUT_DUAL) end)

-- stylua: ignore end

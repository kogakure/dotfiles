require("functions")
require("caffeine")

local application = hs.application
local window      = hs.window
local layout      = hs.layout
local screen      = hs.screen
local hotkey      = hs.hotkey
local hints       = hs.hints


-------------------
-- Configuration --
-------------------

-- Animation
window.animationDuration = 0

-- Hints
hints.fontName        = "Helvetica-Bold"
hints.fontSize        = 18
hints.showTitleThresh = 0
-- hints.style           = "vimperator" -- Buggy, gets slow after a while

-- Allow searching for alternate names
application.enableSpotlightForNameSearches(true)

------------
-- Aliase --
------------

-- Keys
local KEY_AM   = { "⌥", "⌘" }
local KEY_CA   = { "⌃", "⌥" }
local KEY_CAM  = { "⌃", "⌥", "⌘" }
local KEY_CM   = { "⌃", "⌘" }
local KEY_SAM  = { "⇧", "⌥", "⌘" }
local KEY_SC   = { "⇧", "⌘" }
local KEY_SCA  = { "⇧", "⌃", "⌥" }
local KEY_SCAM = { "⇧", "⌃", "⌥", "⌘" }
local KEY_SCM  = { "⇧", "⌃", "⌘" }

-- Displays
local DISPLAY_PRIMARY = screen.primaryScreen()
local DISPLAY_NOTEBOOK = "Color LCD"

-- Sizes
local LEFT_MOST  = hs.geometry.unitrect(0, 0, 0.6, 1)
local LEFT_LESS  = hs.geometry.unitrect(0, 0, 0.4, 1)
local RIGHT_MOST = hs.geometry.unitrect(0.4, 0, 0.6, 1)
local RIGHT_LESS = hs.geometry.unitrect(0.6, 0, 0.4, 1)
local FULLSCREEN = hs.geometry.unitrect(0, 0, 1, 1)
local RIGHT_HALF = hs.geometry.unitrect(0.5, 0, 0.5, 1)
local LEFT_HALF  = hs.geometry.unitrect(0, 0, 0.5, 1)

-------------
-- Layouts --
-------------

-- Format reminder:
-- {"App name", "Window name", "Display Name", "unitrect", "framerect", "fullframerect"},

-- One Monitor and Notebook
local LAYOUT_DUAL = {
  {"Brave Browser",             nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Calendar",                  nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Code",                      nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"DEVONthink 3",              nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Element",                   nil, DISPLAY_NOTEBOOK, RIGHT_HALF, nil, nil},
  {"Firefox Developer Edition", nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Mail",                      nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Messages",                  nil, DISPLAY_PRIMARY,  RIGHT_HALF, nil, nil},
  {"Microsoft Outlook",         nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Music",                     nil, DISPLAY_NOTEBOOK, FULLSCREEN, nil, nil},
  {"Obsidian",                  nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Slack",                     nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Sonos",                     nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Telegram",                  nil, DISPLAY_PRIMARY,  LEFT_HALF,  nil, nil},
  {"Things",                    nil, DISPLAY_NOTEBOOK, FULLSCREEN, nil, nil},
  {"iA Writer",                 nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"kitty",                     nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
}

--  One Monitor
local LAYOUT_SINGLE = {
  {"Brave Browser",             nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Calendar",                  nil, DISPLAY_PRIMARY, LEFT_MOST,  nil, nil},
  {"Code",                      nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"DEVONthink 3",              nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Element",                   nil, DISPLAY_PRIMARY, RIGHT_HALF, nil, nil},
  {"Firefox Developer Edition", nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Mail",                      nil, DISPLAY_PRIMARY, RIGHT_MOST, nil, nil},
  {"Messages",                  nil, DISPLAY_PRIMARY, RIGHT_LESS, nil, nil},
  {"Microsoft Outlook",         nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Music",                     nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Obsidian",                  nil, DISPLAY_PRIMARY,  FULLSCREEN, nil, nil},
  {"Slack",                     nil, DISPLAY_PRIMARY, LEFT_MOST,  nil, nil},
  {"Sonos",                     nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"Telegram",                  nil, DISPLAY_PRIMARY, LEFT_MOST,  nil, nil},
  {"Things",                    nil, DISPLAY_PRIMARY, RIGHT_LESS, nil, nil},
  {"iA Writer",                 nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
  {"kitty",                     nil, DISPLAY_PRIMARY, FULLSCREEN, nil, nil},
}

------------------
-- Key Bindings --
------------------

-- Movement hotkeys
hotkey.bind(KEY_AM, "down",  function() nudge(0, 100) end)
hotkey.bind(KEY_AM, "up",    function() nudge(0, -100) end)
hotkey.bind(KEY_AM, "right", function() nudge(100, 0) end)
hotkey.bind(KEY_AM, "left",  function() nudge(-100, 0) end)

-- Resize hotkeys
hotkey.bind(KEY_SAM, "up",    function() yank(0, -100) end)
hotkey.bind(KEY_SAM, "down",  function() yank(0, 100) end)
hotkey.bind(KEY_SAM, "right", function() yank(100, 0) end)
hotkey.bind(KEY_SAM, "left",  function() yank(-100, 0) end)

-- Push to screen edge
hotkey.bind(KEY_CAM, "left",  function() push(0, 0, 0.5, 1) end)
hotkey.bind(KEY_CAM, "right", function() push(0.5, 0, 0.5, 1) end)
hotkey.bind(KEY_CAM, "up",    function() push(0, 0, 1, 0.5) end)
hotkey.bind(KEY_CAM, "down",  function() push(0, 0.5, 1, 0.5) end)

-- Centered window with some room to see the desktop
hotkey.bind(KEY_SCM, "l", function() push(0.05, 0.05, 0.9, 0.9) end)
hotkey.bind(KEY_SCM, "m", function() push(0.1, 0.1, 0.8, 0.8) end)
hotkey.bind(KEY_SCM, "s", function() push(0.15, 0.15, 0.7, 0.7) end)

-- Fullscreen
hotkey.bind(KEY_CAM, "0", function() push(0, 0, 1, 1) end)

-- Quarter Screens
hotkey.bind(KEY_CAM, "q", function() push(0, 0, 0.5, 0.5) end)
hotkey.bind(KEY_CAM, "w", function() push(0.5, 0, 0.5, 0.5) end)
hotkey.bind(KEY_CAM, "a", function() push(0, 0.5, 0.5, 0.5) end)
hotkey.bind(KEY_CAM, "s", function() push(0.5, 0.5, 0.5, 0.5) end)

-- Part Screens
hotkey.bind(KEY_CAM, "4", function() push(0, 0, 0.6, 1) end)
hotkey.bind(KEY_CAM, "5", function() push(0, 0, 0.4, 1) end)
hotkey.bind(KEY_CAM, "6", function() push(0.4, 0, 0.6, 1) end)
hotkey.bind(KEY_CAM, "7", function() push(0.6, 0, 0.4, 1) end)

-- Move a window between monitors (preserve size)
hotkey.bind(KEY_CM,  "1",     function() window.focusedWindow():moveOneScreenNorth() end)
hotkey.bind(KEY_CM,  "2",     function() window.focusedWindow():moveOneScreenSouth() end)
hotkey.bind(KEY_CM,  "3",     function() window.focusedWindow():moveOneScreenWest() end)
hotkey.bind(KEY_CM,  "up",    function() window.focusedWindow():moveOneScreenNorth() end)
hotkey.bind(KEY_CM,  "down",  function() window.focusedWindow():moveOneScreenSouth() end)
hotkey.bind(KEY_CM,  "right", function() window.focusedWindow():moveOneScreenEast() end)
hotkey.bind(KEY_CM,  "left",  function() window.focusedWindow():moveOneScreenWest() end)
hotkey.bind(KEY_CM,  "k",     function() window.focusedWindow():moveOneScreenNorth() end)
hotkey.bind(KEY_CM,  "j",     function() window.focusedWindow():moveOneScreenSouth() end)
hotkey.bind(KEY_CM,  "l",     function() window.focusedWindow():moveOneScreenEast() end)
hotkey.bind(KEY_CM,  "h",     function() window.focusedWindow():moveOneScreenWest() end)

-- Move a window between monitors (change to fullscreen)
hotkey.bind(KEY_SCM, "1",     function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "2",     function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "3",     function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "up",    function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "down",  function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "right", function() window.focusedWindow():moveOneScreenEast(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "left",  function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "k",     function() window.focusedWindow():moveOneScreenNorth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "j",     function() window.focusedWindow():moveOneScreenSouth(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "l",     function() window.focusedWindow():moveOneScreenEast(); push(0, 0, 1, 1) end)
hotkey.bind(KEY_SCM, "h",     function() window.focusedWindow():moveOneScreenWest(); window.focusedWindow():moveOneScreenWest(); push(0, 0, 1, 1) end)

-- Application shortcuts
hotkey.bind(KEY_SC,   "R", function() application.launchOrFocus("kitty") end)
hotkey.bind(KEY_SCAM, "A", function() application.launchOrFocus("Affinity Designer") end)
hotkey.bind(KEY_SCAM, "B", function() application.launchOrFocus("Brave Browser") end)
hotkey.bind(KEY_SCAM, "C", function() application.launchOrFocus("Visual Studio Code") end)
hotkey.bind(KEY_SCAM, "D", function() application.launchOrFocus("DEVONthink 3") end)
hotkey.bind(KEY_SCAM, "F", function() application.launchOrFocus("Firefox Developer Edition") end)
hotkey.bind(KEY_SCAM, "K", function() application.launchOrFocus("Calendar") end)
hotkey.bind(KEY_SCAM, "L", function() application.launchOrFocus("Microsoft Outlook") end)
hotkey.bind(KEY_SCAM, "M", function() application.launchOrFocus("MindNode") end)
hotkey.bind(KEY_SCAM, "N", function() application.launchOrFocus("Messages") end)
hotkey.bind(KEY_SCAM, "O", function() application.launchOrFocus("Obsidian") end)
hotkey.bind(KEY_SCAM, "P", function() application.launchOrFocus("Podcasts") end)
hotkey.bind(KEY_SCAM, "R", function() application.launchOrFocus("Raindrop.io.app") end)
hotkey.bind(KEY_SCAM, "S", function() application.launchOrFocus("Slack") end)
hotkey.bind(KEY_SCAM, "T", function() application.launchOrFocus("Things3") end)
hotkey.bind(KEY_SCAM, "W", function() application.launchOrFocus("iA Writer") end)
hotkey.bind(KEY_SCAM, "Y", function() application.launchOrFocus("Music") end)

-- Place red circle around mouse
hotkey.bind(KEY_SCAM, "space", mouseHighlight)

-- Manual config reloading (from getting started guide):
hotkey.bind(KEY_CAM, "delete", function() hs.reload() end)

-- Focus
hotkey.bind(KEY_CAM, 'k', function() window.focusedWindow():focusWindowNorth() end)
hotkey.bind(KEY_CAM, 'j', function() window.focusedWindow():focusWindowSouth() end)
hotkey.bind(KEY_CAM, 'l', function() window.focusedWindow():focusWindowEast() end)
hotkey.bind(KEY_CAM, 'h', function() window.focusedWindow():focusWindowWest() end)

-- Hints
hotkey.bind(KEY_CAM, "space", function() hints.windowHints(getAllValidWindows()) end)

-- Layouts
hotkey.bind(KEY_SCAM, "1", function() layout.apply(LAYOUT_SINGLE) end)
hotkey.bind(KEY_SCAM, "2", function() layout.apply(LAYOUT_DUAL) end)

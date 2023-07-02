----------------------
-- Helper Functions --
----------------------

-- Get list of screens and refresh that list whenever screens are plugged or unplugged:
local screens = hs.screen.allScreens()
local screenwatcher = hs.screen.watcher.new(function()
	screens = hs.screen.allScreens()
end)
screenwatcher:start()

-- Move a window a number of pixels in x and y
function Nudge(xpos, ypos)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	f.x = f.x + xpos
	f.y = f.y + ypos
	win:setFrame(f)
end

-- Resize a window by moving the bottom
function Yank(xpixels, ypixels)
	local win = hs.window.focusedWindow()
	local f = win:frame()

	f.w = f.w + xpixels
	f.h = f.h + ypixels
	win:setFrame(f)
end

-- Resize window for chunk of screen.
-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function Push(x, y, w, h)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w * x)
	f.y = max.y + (max.h * y)
	f.w = max.w * w
	f.h = max.h * h
	win:setFrame(f)
end

-- Move to monitor x. Checks to make sure monitor exists, if not moves to last monitor that exists
function MoveToMonitor(x)
	local win = hs.window.focusedWindow()
	local newScreen = nil
	while not newScreen do
		newScreen = screens[x]
		x = x - 1
	end

	win:moveToScreen(newScreen)
end

-- Move to next screen
local function moveToNextScreen(win)
	win = win or window.focusedWindow()
	win:moveToScreen(win:screen():next())
end

-- Move to previous screen
local function moveToPreviousScreen(win)
	win = win or window.focusedWindow()
	win:moveToScreen(win:screen():previous())
end

-- This places a red circle around the mouse pointer
local mouseCircle = nil
local mouseCircleTimer = nil

function MouseHighlight()
	-- Delete an existing highlight if it exists
	if mouseCircle then
		mouseCircle:delete()
		if mouseCircleTimer then
			mouseCircleTimer:stop()
		end
	end
	-- Get the current co-ordinates of the mouse pointer
	Mousepoint = hs.mouse.get()
	-- Prepare a big red circle around the mouse pointer
	mouseCircle = hs.drawing.circle(hs.geometry.rect(Mousepoint.x - 40, Mousepoint.y - 40, 80, 80))
	mouseCircle:setStrokeColor({ ["red"] = 1, ["blue"] = 0, ["green"] = 0, ["alpha"] = 1 })
	mouseCircle:setFill(false)
	mouseCircle:setStrokeWidth(5)
	mouseCircle:show()

	-- Set a timer to delete the circle after 3 seconds
	mouseCircleTimer = hs.timer.doAfter(2, function()
		mouseCircle:delete()
	end)
end

-- Get all valid windows
function GetAllValidWindows()
	local allWindows = hs.window.allWindows()
	local windows = {}
	local index = 1
	for i = 1, #allWindows do
		local w = allWindows[i]
		if w:screen() then
			windows[index] = w
			index = index + 1
		end
	end
	return windows
end

-- Launch application or toggle it
function launchToggleApplication(applicationName)
	local app = hs.application.find(applicationName)

	if app then
		local appWindows = app:visibleWindows()

		if #appWindows > 0 then
			local focusedWindow = app:focusedWindow()

			if focusedWindow then
				if app:isHidden() then
					app:unhide()
				else
					-- Some apps don't allow hiding, so Apple Script is needed
					if app:hide() == false then
						hideApplicationWithAppleScript(app)
					else
						app:hide()
					end
				end
			else
				app:activate()
			end
		else
			app:activate()
		end
	else
		hs.application.launchOrFocus(applicationName)
	end
end

-- Hide application with AppleScript
function hideApplicationWithAppleScript(app)
	local appName = app:name()
	local hideScript = [[
        tell application "Finder"
            set visible of process "%s" to false
        end tell
    ]]
	local formattedScript = string.format(hideScript, appName)
	hs.osascript.applescript(formattedScript)
end

-- Auto Reload Config
function ReloadConfig(files)
	DoReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			DoReload = true
		end
	end
	if DoReload then
		hs.reload()
	end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", ReloadConfig):start()
hs.alert.show("Hammerspoon")

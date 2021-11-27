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
function nudge(xpos, ypos)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.x = f.x + xpos
  f.y = f.y + ypos
  win:setFrame(f)
end


-- Resize a window by moving the bottom
function yank(xpixels, ypixels)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.w = f.w + xpixels
  f.h = f.h + ypixels
  win:setFrame(f)
end


-- Resize window for chunk of screen.
-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function push(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w*x)
  f.y = max.y + (max.h*y)
  f.w = max.w*w
  f.h = max.h*h
  win:setFrame(f)
end


-- Move to monitor x. Checks to make sure monitor exists, if not moves to last monitor that exists
function moveToMonitor(x)
  local win = hs.window.focusedWindow()
  local newScreen = nil
  while not newScreen do
    newScreen = screens[x]
    x = x-1
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

function mouseHighlight()
  -- Delete an existing highlight if it exists
  if mouseCircle then
    mouseCircle:delete()
    if mouseCircleTimer then
      mouseCircleTimer:stop()
    end
  end
  -- Get the current co-ordinates of the mouse pointer
  mousepoint = hs.mouse.get()
  -- Prepare a big red circle around the mouse pointer
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
  mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(5)
  mouseCircle:show()

  -- Set a timer to delete the circle after 3 seconds
  mouseCircleTimer = hs.timer.doAfter(2, function() mouseCircle:delete() end)
end

-- Get all valid windows
function getAllValidWindows()
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

-- Auto Reload Config
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon")

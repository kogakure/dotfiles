-- Replace Caffeine.app with 18 lines of Lua :D
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
  local result
  if state then
    result = caffeine:setIcon("~/.hammerspoon/icons/sun.pdf")
  else
    result = caffeine:setIcon("~/.hammerspoon/icons/moon.pdf")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

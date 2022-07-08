-- Trouble – https://github.com/folke/trouble.nvim
local status, trouble = pcall(require, 'trouble')
if (not status) then
  return
end

trouble.setup()


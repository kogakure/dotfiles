-- nvim-web-devicons
-- https://github.com/kyazdani42/nvim-web-devicons

local status, web_devicons = pcall(require, 'nvim-web-devicons')
if (not status) then return end

web_devicons.setup({
  override = {},
  default = true,
})

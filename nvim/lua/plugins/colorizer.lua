-- The fastest Neovim colorizer
-- https://github.com/NvChad/nvim-colorizer.lua
return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "yaml",
      "conf",
      "lua",
    }, {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background",
    })
  end,
}

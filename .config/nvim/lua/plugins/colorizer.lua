-- The fastest Neovim colorizer
-- https://github.com/NvChad/nvim-colorizer.lua
return {
  "NvChad/nvim-colorizer.lua",
  opts = {
    filetypes = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "yaml",
      "conf",
      "lua",
    },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = "background",
    },
  },
}

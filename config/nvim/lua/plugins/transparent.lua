-- Remove all background colors to make Neovim transparent
-- https://github.com/xiyaowong/nvim-transparent
return {
  "xiyaowong/nvim-transparent",
  opts = {
    extra_groups = {
      "TelescopeBorder",
      "TelescopeNormal",
      -- "NeoTreeNormal",
      -- "NeoTreeNormalNC",
    },
  },
}

-- Remove all background colors to make Neovim transparent
-- https://github.com/xiyaowong/nvim-transparent
return {
  "xiyaowong/nvim-transparent",
  opts = {
    enable = false,
    extra_groups = {
      "TelescopeBorder",
      "TelescopeNormal",
    },
  },
}

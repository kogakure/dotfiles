--  https://github.com/folke/tokyonight.nvim
--  https://github.com/chriskempson/base16-vim
--  https://github.com/kartikp10/noctis.nvim
--  https://github.com/catppuccin/nvim
return {
  "folke/tokyonight.nvim", -- Tokyo Night color scheme
  "chriskempson/base16-vim", -- Base16 colorschemes
  { "kartikp10/noctis.nvim", dependencies = "rktjmp/lush.nvim" }, -- Noctis color scheme
  { "catppuccin/nvim", name = "catppuccin" }, -- Catppuccin color scheme

  -- Configure LazyVim to load Tokyo Night
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}

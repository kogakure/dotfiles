-- 🦉 🌌 Night Owl colorscheme implementation for Neovim with support for Treesitter and semantic tokens
-- https://github.com/oxfist/night-owl.nvim
return {
  "oxfist/night-owl.nvim",
  lazy = true,
  config = function()
    require("night-owl").setup()
    vim.cmd.colorscheme("night-owl")
  end,
}

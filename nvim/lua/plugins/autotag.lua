-- Use treesitter to auto close and auto rename HTML tags
-- https://github.com/windwp/nvim-ts-autotag
return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup({
      disable_filetype = { "TelescopePrompt", "vim" },
    })
  end,
}

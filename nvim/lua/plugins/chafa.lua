-- View images in Neovim
-- https://github.com/princejoogie/chafa.nvim
return {
  "princejoogie/chafa.nvim",
  cond = vim.g.vscode == nil,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim",
  },
  config = function()
    require("chafa").setup({
      render = {
        min_padding = 5,
        show_label = true,
      },
      events = {
        update_on_nvim_resize = true,
      },
    })
  end,
}

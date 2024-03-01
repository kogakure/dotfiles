-- Create code images using the external silicon tool
-- https://github.com/michaelrommel/nvim-silicon
return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    require("silicon").setup({
      font = "Fira Code=34;Noto Emoji=34",
      theme = "Catppuccin-mocha",
      background = "#68677b",
      pad_horiz = 100,
      pad_vert = 80,
      no_round_corner = false,
      no_window_controls = false,
      no_line_number = false,
      line_pad = 0,
      tab_width = 2,
      language = function()
        return vim.bo.filetype
      end,
      shadow_blur_radius = 16,
      shadow_offset_x = 8,
      shadow_offset_y = 8,
      shadow_color = "#100808",
      gobble = true,
      to_clipboard = true,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
      end,
    })
  end,
}

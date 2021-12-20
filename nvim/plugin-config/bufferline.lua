-- bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim

local status, bufferline = pcall(require, 'bufferline')
if (not status) then return end

bufferline.setup({
  highlights = {
    fill = {
      guibg = "#282828"
    },
    separator_selected = {
      guifg = "#282828"
    },
    separator_visible = {
      guifg = "#282828"
    },
    separator = {
      guifg = "#282828"
    }
  },
  options = {
    modified_icon = "●",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 25,
    max_prefix_length = 25,
    enforce_regular_tabs = false,
    view = "multiwindow",
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
})

-- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Leader>tp', [[<Cmd>:BufferLinePick<CR>]],      opts)
vim.api.nvim_set_keymap('n', '<Leader>tx', [[<Cmd>:BufferLinePickClose<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>H',  [[<Cmd>:BufferLineCyclePrev<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>L',  [[<Cmd>:BufferLineCycleNext<CR>]], opts)

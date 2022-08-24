-- bufferline.nvim – https://github.com/akinsho/bufferline.nvim
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

bufferline.setup({
	highlights = {
		fill = {
			bg = "#282828",
		},
		tab_selected = {
			fg = {
				attribute = "fg",
				highlight = "Normal",
			},
			bg = {
				attribute = "bg",
				highlight = "Normal",
			},
		},
		tab = {
			fg = {
				attribute = "fg",
				highlight = "TabLine",
			},
			bg = {
				attribute = "bg",
				highlight = "TabLine",
			},
		},
		indicator_selected = {
			fg = {
				attribute = "fg",
				highlight = "LspDiagnosticsDefaultHint",
			},
			bg = {
				attribute = "bg",
				highlight = "Normal",
			},
		},
	},
	options = {
		modified_icon = "●",
		left_trunc_marker = "",
		right_trunc_marker = "",
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
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
			return "(" .. count .. ")"
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

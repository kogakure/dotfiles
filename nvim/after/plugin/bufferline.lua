-- https://github.com/akinsho/bufferline.nvim
require("bufferline").setup({
	highlights = {
		fill = {
			bg = "None",
		},
		background = {
			bg = "None",
		},
		tab = {
			bg = "None",
		},
		tab_selected = {
			bg = "None",
		},
		tab_close = {
			bg = "None",
		},
		close_button = {
			bg = "None",
		},
		close_button_visible = {
			bg = "None",
		},
		close_button_selected = {
			bg = "None",
		},
		buffer_visible = {
			bg = "None",
		},
		buffer_selected = {
			bg = "None",
			bold = true,
		},
		numbers = {
			bg = "None",
		},
		numbers_visible = {
			bg = "None",
		},
		numbers_selected = {
			bg = "None",
			bold = true,
		},
		diagnostic = {
			bg = "None",
		},
		diagnostic_visible = {
			bg = "None",
		},
		diagnostic_selected = {
			bg = "None",
			bold = true,
		},
		hint = {
			bg = "None",
		},
		hint_visible = {
			bg = "None",
		},
		hint_selected = {
			bg = "None",
			bold = true,
		},
		hint_diagnostic = {
			bg = "None",
		},
		hint_diagnostic_visible = {
			bg = "None",
		},
		hint_diagnostic_selected = {
			bg = "None",
			bold = true,
		},
		info = {
			bg = "None",
		},
		info_visible = {
			bg = "None",
		},
		info_selected = {
			bg = "None",
			bold = true,
		},
		info_diagnostic = {
			bg = "None",
		},
		info_diagnostic_visible = {
			bg = "None",
		},
		info_diagnostic_selected = {
			bg = "None",
			bold = true,
		},
		warning = {
			bg = "None",
		},
		warning_visible = {
			bg = "None",
		},
		warning_selected = {
			bg = "None",
			bold = true,
		},
		warning_diagnostic = {
			bg = "None",
		},
		warning_diagnostic_visible = {
			bg = "None",
		},
		warning_diagnostic_selected = {
			bg = "None",
			bold = true,
		},
		error = {
			bg = "None",
		},
		error_visible = {
			bg = "None",
		},
		error_selected = {
			bg = "None",
			bold = true,
		},
		error_diagnostic = {
			bg = "None",
		},
		error_diagnostic_visible = {
			bg = "None",
		},
		error_diagnostic_selected = {
			bg = "None",
			bold = true,
		},
		modified = {
			bg = "None",
		},
		modified_visible = {
			bg = "None",
		},
		modified_selected = {
			bg = "None",
		},
		duplicate_selected = {
			bg = "None",
			italic = true,
		},
		duplicate_visible = {
			bg = "None",
			italic = true,
		},
		duplicate = {
			bg = "None",
			italic = true,
		},
		separator_selected = {
			bg = "None",
		},
		separator_visible = {
			bg = "None",
		},
		separator = {
			bg = "None",
		},
		indicator_selected = {
			bg = "None",
		},
		pick_selected = {
			bg = "None",
			bold = true,
			italic = true,
		},
		pick_visible = {
			bg = "None",
			bold = true,
			italic = true,
		},
		pick = {
			bg = "None",
			bold = true,
			italic = true,
		},
		offset_separator = {
			bg = "None",
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

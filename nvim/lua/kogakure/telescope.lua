-- telescope.nvim – https://github.com/nvim-telescope/telescope.nvim/
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local actions = require("telescope.actions")

-- Extensions
telescope.load_extension("bookmarks")
telescope.load_extension("node_modules")
telescope.load_extension("file_browser")
telescope.load_extension("frecency")
telescope.load_extension("lsp_handlers")
telescope.load_extension("fzf")
telescope.load_extension("harpoon")
telescope.load_extension("projects")

-- Keymaps
keymap("n", "<leader>bm", [[<Cmd>Telescope bookmarks<CR>]], opts)
keymap("n", "<leader>gb", [[<Cmd>Telescope git_branches<CR>]], opts)
keymap("n", "<leader>gs", [[<Cmd>Telescope git_status<CR>]], opts)
keymap("n", "<leader>ht", [[<Cmd>Telescope help_tags<CR>]], opts)
keymap("n", "<leader>km", [[<Cmd>Telescope keymaps<CR>]], opts)
keymap("n", "<leader>m", [[<Cmd>Telescope marks<CR>]], opts)
keymap("n", "<leader>mru", [[<Cmd>Telescope frecency<CR>]], opts)
keymap("n", "<leader>nm", [[<Cmd>Telescope node_modules list<CR>]], opts)
keymap("n", "<leader>tb", [[<Cmd>Telescope buffers<CR>]], opts)
keymap("n", "<leader>C", [[<Cmd>:Cheatsheet<CR>]], opts)
keymap("n", "<leader>tf", [[<Cmd>Telescope find_files<CR>]], opts)
keymap("n", "<leader>tfa", [[<Cmd>Telescope find_files hidden=true<CR>]], opts)
keymap("n", "<leader>tfb", [[<Cmd>Telescope file_browser<CR>]], opts)
keymap("n", "<leader>tg", [[<Cmd>Telescope tags<CR>]], opts)
keymap("n", "<leader>tlg", [[<Cmd>Telescope live_grep<CR>]], opts)
keymap("n", "<leader>tr", [[<Cmd>Telescope resume<CR>]], opts)

-- Setup
telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = {
			"smart",
		},
		file_ignore_pattern = {
			"yarn.lock",
		},
		mappings = {
			-- INSERT Mode
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},
			-- NORMAL Mode
			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		buffers = {
			theme = "dropdown",
			previewer = false,
			show_all_buffers = true,
			sort_lastused = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
		},
		frecency = {
			show_scores = false,
			show_unindexed = true,
			ignore_patterns = {
				"*.git/*",
				"*/tmp/*",
			},
			disable_devicons = false,
		},
		bookmarks = {
			selected_browser = "brave",
			url_open_command = "open",
		},
		lsp_handlers = {
			disable = {},
			location = {
				telescope = {},
				no_results_message = "No references found",
			},
			symbol = {
				telescope = {},
				no_results_message = "No symbols found",
			},
			call_hierarchy = {
				telescope = {},
				no_results_message = "No calls found",
			},
			code_action = {
				telescope = require("telescope.themes").get_dropdown({}),
				no_results_message = "No code actions available",
				prefix = "",
			},
		},
	},
})

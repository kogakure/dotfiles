-- https://github.com/folke/which-key.nvim
local which_key = require("which-key")

local mappings = {
	b = { "<CMD>Telescope buffers<CR>", "Buffers" },
	c = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
	d = { "<CMD>TroubleToggle<CR>", "Diagnostics" },
	e = { "<CMD>NvimTreeToggle<CR>", "Explorer" },
	f = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "Find Files" },
	h = { "<CMD>nohlsearch<CR>", "No Highlight" },
	i = { "<CMD>silent !open -a iA\\ Writer.app '%:p'<CR>", "iA Writer" },
	j = { "<CMD>b#<CR>", "Toggle Buffers" },
	o = { "<CMD>SymbolsOutline<CR>", "Symbols Outline" },
	p = { "<CMD>Pounce<CR>", "Pounce" },
	q = { "<CMD>Bdelete!<CR>", "Close Buffer" },
	s = {
		"<CMD>lua require('spectre').open_file_search()<CR>",
		"Spectre",
	},
	t = { "<CMD>TodoTelescope<CR>", "Todo" },
	v = { "<CMD>lua require('export-to-vscode').launch()<CR>", "Visual Studio Code" },
	w = { "<CMD>w!<CR>", "Save" },
	x = {
		name = "Text Editing",
		c = { "<CMD>call ToggleColorColumn()<CR>", "Show/Hide Colorcolumn" },
		d = { "<CMD>call SpellEn()<CR>", "Set Spelling Language to English" },
		e = { "<CMD>call SpellDe()<CR>", "Set Spelling Languate to German" },
		l = { "<CMD>set list!<CR>", "List" },
		m = { "<CMD>MarkdownPreviewToggle<CR>", "Markdown Preview" },
		s = { "<CMD>set spell!<CR>", "Spell Checking" },
		w = { "<CMD>call ToggleWrap()<CR>", "Soft wrap/No wrap" },
	},
	z = { "<CMD>ZenMode<CR>", "Zen Mode" },
	A = { "<CMD>Alpha<CR>", "Alpha" },
	B = {
		name = "Bufferline",
		p = { "<CMD>BufferLinePick<CR>", "Pick" },
		x = { "<CMD>BufferLinePickClose<CR>", "Pick to Close" },
	},
	E = {
		name = "Explorer",
		a = { "<CMD>NvimTreeFocus<CR>", "Focus" },
		c = { "<CMD>NvimTreeCollapse<CR>", "Collapse Folders" },
		f = { "<CMD>NvimTreeFindFile<CR>", "Find File" },
		r = { "<CMD>NvimTreeRefresh<CR>", "Refresh" },
	},
	F = { "<CMD>Telescope live_grep<CR>", "Find Text" },
	G = {
		name = "Git & GitHub",
		b = { "<CMD>BlamerToggle<CR>", "Blame Line" },
		g = { "<CMD>GBInteractive<CR>", "Git Blame in GitHub" },
		h = { "<CMD>GHInteractive<CR>", "Open in GitHub" },
	},
	L = {
		name = "LSP, FZF & Telescope",
		L = {
			name = "LSP",
			a = { "<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace" },
			c = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "LSP Code Action" },
			d = { "<Cmd>Telescope lsp_definitions<CR>", "LSP Definitions" },
			l = { "<CMD>lua vim.diagnostic.setloclist<CR>", "Set Loclist" },
			r = { "<Cmd>Telescope lsp_references<CR>", "LSP References" },
			s = { "<Cmd>Telescope lsp_document_symbols<CR>", "LSP Document Symbols" },
			t = { "<Cmd>Telescope lsp_type_definitions<CR>", "LSP Type Definition" },
			v = { "<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace" },
			w = { "<Cmd>Telescope lsp_workspace_symbols<CR>", "LSP Live Workspace Symbols" },
		},
		F = {
			name = "FZF",
			b = { "<Cmd>FzfLua blines<CR>", "Bufferlines" },
			f = { "<Cmd>FzfLua files<CR>", "Files" },
			h = { "<Cmd>FzfLua oldfiles<CR>", "Open Files History" },
			i = { "<Cmd>FzfLua spell_suggest<CR>", "Spelling Suggestions" },
			m = { "<Cmd>FzfLua marks<CR>", "Marks" },
			o = { "<Cmd>FzfLua lines<CR>", "Open Buffer Lines" },
			q = { "<Cmd>FzfLua quickfix<CR>", "Quickfix" },
			r = { "<Cmd>FzfLua resume<CR>", "Resume last command" },
			t = { "<Cmd>FzfLua tabs<CR>", "Tabs" },
			g = {
				name = "Git",
				b = { "<Cmd>FzfLua git_branches<CR>", "Git Branches" },
				c = { "<Cmd>FzfLua git_commits<CR>", "Git Commits" },
				s = { "<Cmd>FzfLua git_stash<CR>", "Git Stashes" },
				t = { "<Cmd>FzfLua git_status<CR>", "Git Status" },
			},
			s = {
				name = "Search",
				s = { "<Cmd>FzfLua grep<CR>", "Grep Search" },
				i = { "<Cmd>FzfLua live_grep<CR>", "Live Grep" },
				l = { "<Cmd>FzfLua grep_last<CR>", "Last Grep Search" },
				r = { "<Cmd>FzfLua live_grep_resume<CR>", "Resume Last Search" },
				c = { "<Cmd>FzfLua grep_cword<CR>", "Search Word Under Cursor" },
				v = { "<Cmd>FzfLua grep_visual<CR>", "Search Visual Selection" },
				p = { "<Cmd>FzfLua grep_project<CR>", "Grep Search in Project" },
			},
		},
		T = {
			name = "Telescope",
			b = { "<Cmd>Telescope bookmarks<CR>", "Browser Bookmarks" },
			f = {
				name = "Find",
				s = { "<Cmd>Telescope find_files<CR>", "Find Files" },
				a = { "<Cmd>Telescope find_files hidden=true<CR>", "Find all files" },
				f = { "<Cmd>Telescope file_browser<CR>", "File Browser" },
				l = { "<Cmd>Telescope live_grep<CR>", "Live Grep" },
			},
			g = {
				name = "Git",
				b = { "<Cmd>Telescope git_branches<CR>", "Git Branches" },
				s = { "<Cmd>Telescope git_status<CR>", "Git Status" },
			},
			h = { "<Cmd>Telescope help_tags<CR>", "Help Tags" },
			k = { "<Cmd>Telescope keymaps<CR>", "Keymaps" },
			m = { "<Cmd>Telescope marks<CR>", "Marks" },
			n = { "<Cmd>Telescope node_modules list<CR>", "Node Modules" },
			p = { "<CMD>Telescope projects<CR>", "Projects" },
			r = { "<Cmd>Telescope resume<CR>", "Resume last search" },
			t = { "<Cmd>Telescope tags<CR>", "Tags" },
			u = { "<Cmd>Telescope frecency<CR>", "MRU (Frequency)" },
		},
	},
	P = { "<CMD>Telescope projects<CR>", "Projects" },
	Q = { "<CMD>q!<CR>", "Quit" },
	R = { "<CMD>lua vim.lsp.buf.rename()<CR>", "Rename" },
	S = { "<CMD>lua require('spectre').open_visual({select_word=true})<CR>", "Spectre Current Word" },
	T = {
		name = "Terminal",
		f = { "<CMD>ToggleTerm direction=float<CR>", "Float" },
		g = { "<CMD>lua _TIG_TOGGLE()<CR>", "TIG" },
		h = { "<CMD>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
		l = { "<CMD>lua _LAZYGIT_TOGGLE()<CR>", "LazyGit" },
		n = { "<CMD>lua _NODE plugin_TOGGLE()<CR>", "Node" },
		p = { "<CMD>lua _PYTHON_TOGGLE()<CR>", "Python" },
		t = { "<CMD>lua _HTOP_TOGGLE()<CR>", "Htop" },
		u = { "<CMD>lua _NCDU_TOGGLE()<CR>", "NCDU" },
		v = { "<CMD>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
	},
	V = {
		name = "Vimux",
		p = { "<CMD>VimuxPromptCommand<CR>", "Run Prompt Command" },
		l = { "<CMD>VimuxRunLastCommand<CR>", "Run Last Command" },
		t = { "<CMD>VimuxTogglePane<CR>", "Toggle Pane" },
		j = { "<CMD>RunJest<CR>", "Run Jest" },
		b = { "<CMD>RunJestOnBuffer<CR>", "Run Jest on Buffer" },
		f = { "<CMD>RunJestFocused<CR>", "Run Jest on Focused" },
	},
	W = { "<CMD>wa!<CR>", "Save All" },
}

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn’t effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<CR>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it’s label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn’t specify a label
	hidden = { "<silent>", "<CMD>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
	["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

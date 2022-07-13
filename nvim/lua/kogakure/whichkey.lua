local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local mappings = {
	b = {
		"<CMD>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
		"Buffers",
	},
	c = { "<CMD>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
	d = { "<CMD>TroubleToggle<CR>", "Diagnostics" },
	e = { "<CMD>NvimTreeToggle<CR>", "Explorer" },
	f = { "<CMD>FzfLua files<CR>", "Find Files" },
	h = { "<CMD>nohlsearch<CR>", "No Highlight" },
	j = { "<CMD>b#<CR>", "Toggle Buffers" },
	i = { "<CMD>silent !open -a iA\\ Writer.app '%:p'<CR>", "Open in iA Writer" },
	p = { "<CMD>Telescope projects<CR>", "Projects" },
	q = { "<CMD>Bdelete!<CR>", "Close Buffer" },
	s = {
		a = { "<Cmd>:FzfLua lsp_code_actions<CR>", "LSP Code Actions" },
		d = { "<Cmd>:FzfLua lsp_definitions<CR>", "LSP Definitions" },
		s = { "<Cmd>:FzfLua lsp_document_symbols<CR>", "LSP Document Symbols" },
		w = { "<Cmd>:FzfLua lsp_live_workspace_symbols<CR>", "LSP Live Workspace Symbols" },
		r = { "<Cmd>:FzfLua lsp_references<CR>", "LSP References" },
		t = { "<Cmd>:FzfLua lsp_typedef<CR>", "LSP Type Definition" },
		name = "Search",
		F = {
			name = "FZF",
			b = { "<Cmd>:FzfLua blines<CR>", "Bufferlines" },
			f = { "<Cmd>:FzfLua files<CR>", "Files" },
			h = { "<Cmd>:FzfLua oldfiles<CR>", "Open Files History" },
			i = { "<Cmd>:FzfLua spell_suggest<CR>", "Spelling Suggestions" },
			m = { "<Cmd>:FzfLua marks<CR>", "Marks" },
			o = { "<Cmd>:FzfLua lines<CR>", "Open Buffer Lines" },
			q = { "<Cmd>:FzfLua quickfix<CR>", "Quickfix" },
			r = { "<Cmd>:FzfLua resume<CR>", "Resume last command" },
			t = { "<Cmd>:FzfLua tabs<CR>", "Tabs" },
			g = {
				name = "Git",
				b = { "<Cmd>:FzfLua git_branches<CR>", "Git Branches" },
				c = { "<Cmd>:FzfLua git_commits<CR>", "Git Commits" },
				s = { "<Cmd>:FzfLua git_stash<CR>", "Git Stashes" },
				t = { "<Cmd>:FzfLua git_status<CR>", "Git Status" },
			},
			s = {
				name = "Search",
				s = { "<Cmd>:FzfLua grep<CR>", "Grep Search" },
				i = { "<Cmd>:FzfLua live_grep<CR>", "Live Grep" },
				l = { "<Cmd>:FzfLua grep_last<CR>", "Last Grep Search" },
				r = { "<Cmd>:FzfLua live_grep_resume<CR>", "Resume Last Search" },
				c = { "<Cmd>:FzfLua grep_cword<CR>", "Search Word Under Cursor" },
				v = { "<Cmd>:FzfLua grep_visual<CR>", "Search Visual Selection" },
				p = { "<Cmd>:FzfLua grep_project<CR>", "Grep Search in Project" },
			},
		},
		T = {
			name = "Telescope",
			u = { "<Cmd>Telescope frecency<CR>", "MRU (Frequency)" },
			r = { "<Cmd>Telescope resume<CR>", "Resume last search" },
			b = { "<Cmd>Telescope bookmarks<CR>", "Browser Bookmarks" },
			m = { "<Cmd>Telescope marks<CR>", "Marks" },
			n = { "<Cmd>Telescope node_modules list<CR>", "Node Modules" },
			k = { "<Cmd>Telescope keymaps<CR>", "Keymaps" },
			h = { "<Cmd>Telescope help_tags<CR>", "Help Tags" },
			t = { "<Cmd>Telescope tags<CR>", "Tags" },
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
		},
		S = {
			name = "Spectre",
			f = { "<CMD>lua require('spectre').open_file_search()<CR>", "File Search" },
			c = { "<CMD>lua require('spectre').open_visual({select_word=true})<CR>", "Search Current Word" },
		},
	},
	t = {
		name = "Terminal",
		f = { "<CMD>ToggleTerm direction=float<CR>", "Float" },
		g = { "<CMD>lua _TIG_TOGGLE()<CR>", "TIG" },
		h = { "<CMD>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
		l = { "<CMD>lua _LAZYGIT_TOGGLE()<CR>", "LazyGit" },
		n = { "<CMD>lua _NODE_TOGGLE()<CR>", "Node" },
		p = { "<CMD>lua _PYTHON_TOGGLE()<CR>", "Python" },
		t = { "<CMD>lua _HTOP_TOGGLE()<CR>", "Htop" },
		u = { "<CMD>lua _NCDU_TOGGLE()<CR>", "NCDU" },
		v = { "<CMD>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
	},
	v = { "<CMD>lua require('export-to-vscode').launch()<CR>", "Export to Visual Studio Code" },
	w = { "<CMD>w!<CR>", "Save" },
	z = {
		name = "Zen",
		g = { "<CMD>Goyo<CR>", "Goyo" },
		z = { "<CMD>ZenMode<CR>", "ZenMode" },
		t = { "<CMD>Twilight<CR>", "Twilight Mode" },
	},
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
	F = { "<CMD>FzfLua live_grep<CR>", "Find Text" },
	G = {
		name = "Git & GitHub",
		b = { "<CMD>BlamerToggle<CR>", "Blame Line" },
		g = { "<CMD>GBInteractive<CR>", "Git Blame in GitHub" },
		h = { "<CMD>GHInteractive<CR>", "Open in GitHub" },
	},
	L = {
		name = "LSP",
		c = { "<CMD>vim.lsp.buf.code_action<CR>", "Code Action" },
		b = { "<CMD>FzfLua blines<CR>", "Buffer Lines" },
		f = { "<CMD>vim.lsp.buf.formatting<CR>", "Formatting" },
		l = { "<CMD>vim.diagnostic.setloclist<CR>", "Set Loclist" },
		r = { "<CMD>vim.lsp.buf.rename<CR>", "Rename" },
		t = { "<CMD>vim.lsp.buf.type_definition<CR>", "Type Definition" },
		w = { "<CMD>function() print(vim.inspect(vim.lsp.buf.list_workspace_folders()))", "List Workspace Folder" },
		a = { "<CMD>vim.lsp.buf.add_workspace_folder<CR>", "Add Workspace" },
		v = { "<CMD>vim.lsp.buf.remove_workspace_folder<CR>", "Remove Workspace" },
	},
	P = {
		name = "Packer",
		c = { "<CMD>PackerCompile<CR>", "Compile" },
		i = { "<CMD>PackerInstall<CR>", "Install" },
		s = { "<CMD>PackerSync<CR>", "Sync" },
		S = { "<CMD>PackerStatus<CR>", "Status" },
		u = { "<CMD>PackerUpdate<CR>", "Update" },
	},
	Q = { "<CMD>q!<CR>", "Quit" },
	R = { "<CMD>luafile %<CR>", "Reload File" },
	T = {
		name = "Text Editing",
		s = { "<CMD>:set spell!<CR>", "Spell Checking" },
		d = { "<CMD>call SpellEn()<CR>", "Set Spelling Language to English" },
		e = { "<CMD>call SpellDe()<CR>", "Set Spelling Languate to German" },
		w = { "<CMD>call ToggleWrap()<CR>", "Soft wrap/No wrap" },
		c = { "<CMD>call ToggleColorColumn()<CR>", "Show/Hide Colorcolumn" },
		m = { "<CMD>MarkdownPreviewToggle<CR>", "Markdown Preview" },
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

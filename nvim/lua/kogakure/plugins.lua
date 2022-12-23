-- Lazy.nvim - https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.runtimepath:prepend(lazypath)

local plugins = {
	"nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
	"nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins

	-- Colorscheme
	"chriskempson/base16-vim", -- Base16 colorschemes
	"folke/tokyonight.nvim", -- Tokyo Night color scheme
	{ "catppuccin/nvim", name = "catppuccin" }, -- Catppuccin color scheme

	-- CMP
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- Buffer completions
	"hrsh7th/cmp-path", -- Path completions
	"hrsh7th/cmp-cmdline", -- Cmdline completions
	"hrsh7th/cmp-nvim-lua", -- Lua API completions
	"hrsh7th/cmp-copilot", -- GitHub Copilot completions
	"saadparwaiz1/cmp_luasnip", -- Snippet completions
	"uga-rosa/cmp-dictionary", -- Dictionary completions
	"f3fora/cmp-spell", -- Spell completions
	"David-Kunz/cmp-npm", -- NPM package completions
	"hrsh7th/cmp-nvim-lsp", -- LSP completions
	"hrsh7th/cmp-nvim-lsp-signature-help", -- LSP Signature Help

	-- Snippets
	"L3MON4D3/LuaSnip", -- Snippet Engine
	"rafamadriz/friendly-snippets", -- A bunch of snippets

	-- LSP
	"neovim/nvim-lspconfig", -- Enable LSP
	"williamboman/mason.nvim", -- Manage LSP servers, DAP servers, linters, and formatters
	"williamboman/mason-lspconfig.nvim", -- Bridge betwen Mason and lspconfig
	"jay-babu/mason-null-ls.nvim", -- Bridge between Mason and null-ls
	"jose-elias-alvarez/null-ls.nvim", -- Inject LSP diagnostics, code actions, and more
	"folke/trouble.nvim", -- Diagnostics
	"creativenull/diagnosticls-configs-nvim", -- Collection of linters and formatters
	"tamago324/nlsp-settings.nvim", -- LSP for json/yaml
	{ "kosayoda/nvim-lightbulb", dependencies = "antoinemadec/FixCursorHold.nvim" },

	-- FZF
	{ "junegunn/fzf", build = "./install --bin" },
	"ibhagwan/fzf-lua",

	-- Telescope
	"nvim-telescope/telescope.nvim",
	"dhruvmanila/telescope-bookmarks.nvim", -- Open browser bookmarks
	"nvim-telescope/telescope-file-browser.nvim", -- File and folder actions
	"sudormrfbin/cheatsheet.nvim", -- Searchable cheatsheet
	"nvim-telescope/telescope-node-modules.nvim", -- node_modules packages
	"gbrlsnchs/telescope-lsp-handlers.nvim", -- LSP handlers
	"crispgm/telescope-heading.nvim", -- Jump between headings
	"nvim-telescope/telescope-fzy-native.nvim", -- FZY style sorter that is compiled
	{ "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sqlite.lua" } }, -- Frequency and recency
	"nvim-telescope/telescope-github.nvim", -- GitHub CLI
	"nvim-telescope/telescope-symbols.nvim", -- Symbols
	"princejoogie/dir-telescope.nvim", -- Perform functions in selected directory

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"p00f/nvim-ts-rainbow", -- Rainbox parentheses
	"nvim-treesitter/playground", -- Treesitter information in Neovim
	"nvim-treesitter/nvim-treesitter-context", -- Show context

	-- DAP
	"mfussenegger/nvim-dap", -- Debug Adapter Protocol

	-- File/Window Management
	"ThePrimeagen/harpoon", --  Getting you where you want
	"ThePrimeagen/git-worktree.nvim", -- Git Worktree
	"lewis6991/gitsigns.nvim", -- Git decorations
	"kyazdani42/nvim-web-devicons", -- Icons and colors for file types
	"kyazdani42/nvim-tree.lua", -- A File Explorer
	"akinsho/bufferline.nvim", -- Emulate tabs for buffers
	"moll/vim-bbye", -- Delete buffers without closing the window
	"akinsho/toggleterm.nvim", -- Terminal in Neovim
	"nvim-lualine/lualine.nvim", -- Statusline
	"norcalli/nvim-colorizer.lua", -- Highlight colors
	"ahmedkhalf/project.nvim", -- Project Management
	"lewis6991/impatient.nvim", -- Speed Up Startup
	"lukas-reineke/indent-blankline.nvim", -- Indentation guides
	"goolord/alpha-nvim", -- Customizable Greeter
	"antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
	"MattesGroeger/vim-bookmarks", -- Bookmarks
	"folke/which-key.nvim", -- Display possible keybindings
	"mrjones2014/legendary.nvim", -- Legend for keymaps, commands, and autocommands
	"APZelos/blamer.nvim", -- Git Blame
	"tpope/vim-fugitive", -- Git plugin
	"elijahmanor/export-to-vscode.nvim", -- Export active Buffers to Visual Studio Code
	"bogado/file-line", -- Jump directly to line in file with 'nvim index.html:20'
	"ruanyl/vim-gh-line", -- Open current line in GitHub
	"pwntester/octo.nvim", -- GitHub in Neovim
	"nvim-pack/nvim-spectre", -- Search and replace
	"stevearc/dressing.nvim", -- Improve the default vim.ui interfaces
	"folke/zen-mode.nvim", -- Zen Mode
	"tpope/vim-eunuch", -- UNIX Shell commands
	"folke/twilight.nvim", -- Dim inactive code
	"ray-x/guihua.lua", -- Lua GUI lib
	"ray-x/sad.nvim", -- Find & Replace
	"gorbit99/codewindow.nvim", -- Minimap
	"simrat39/symbols-outline.nvim", -- Symbols Outline
	"SmiteshP/nvim-navic", -- Statusline current context
	"kevinhwang91/nvim-bqf", -- Better Quickfix
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" }, -- Better folds
	"debugloop/telescope-undo.nvim", -- Undo history
	"mrjones2014/smart-splits.nvim", -- Smart splits
	"xiyaowong/nvim-transparent", -- Remove all background colors
	"nanotee/zoxide.vim", -- zoxide integration
	"is0n/fm-nvim", -- terminal file managers

	-- Editing Files
	"windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
	"windwp/nvim-ts-autotag", -- Autoclose and autorename html tags
	"numToStr/Comment.nvim", -- Easily comment stuff
	"JoosepAlviste/nvim-ts-context-commentstring", -- Comment based on cursor location of file
	{ "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
	"yamatsum/nvim-cursorline", -- Highlight words and lines on the cursor
	"mattn/emmet-vim", -- Emmet
	"editorconfig/editorconfig-vim", -- Editorconfig
	"sheerun/vim-polyglot", -- A collection of language packs (?,
	"tpope/vim-abolish", -- Autofix spelling mistakes
	"mg979/vim-visual-multi", -- Multi cursor mode
	"vim-scripts/VisIncr", -- Increase and decreasing numbers, dates, daynames etc.
	"monaqa/dial.nvim", -- Increase and decrease numbers, dates, times, etc
	"rstacruz/vim-xtract", -- Extract code into new file
	"tpope/vim-repeat", -- Repeat plugins
	"kylechui/nvim-surround", -- Surround selections, stylishly
	"wuelnerdotexe/vim-astro", -- Astro support
	"MunifTanjim/prettier.nvim", -- Prettier
	"untitled-ai/jupyter_ascending.vim", -- Interact with jupyter_ascending
	"rhysd/vim-grammarous", -- A powerful grammar checker for Vim using LanguageTool
	"mechatroner/rainbow_csv", -- Rainbow CSV
	"dbeniamine/cheat.sh-vim", -- Cheat.sh
	"wakatime/vim-wakatime", -- Wakatime
	"github/copilot.vim", -- GitHub Copilot
	"folke/todo-comments.nvim", -- Highlight TODO
	"DNLHC/glance.nvim", -- Pretty preview of LSP locations
	"rlane/pounce.nvim", -- Incremental fuzzy search motion
	"echasnovski/mini.nvim", -- Library with 20+ plugins
	"dhruvasagar/vim-table-mode", -- Markdown table mode

	-- Custom Text Objects
	"chrisgrieser/nvim-various-textobjs", -- Various text objects
	"nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects
	{ "glts/vim-textobj-comment", dependencies = { "kana/vim-textobj-user" } }, -- ac, ic, aC
	{ "jceb/vim-textobj-uri", dependencies = { "kana/vim-textobj-user" } }, -- au, iu, go
	{ "kana/vim-textobj-datetime", dependencies = { "kana/vim-textobj-user" } }, -- ada, add, adf, adt, adz, ida, …
	{ "kana/vim-textobj-indent", dependencies = { "kana/vim-textobj-user" } }, -- Text objects for indentation
	{ "whatyouhide/vim-textobj-xmlattr", dependencies = { "kana/vim-textobj-user" } }, -- ax, ix

	-- Custom Motions
	"tommcdo/vim-exchange", -- cx, cxx, X, cxc
	"easymotion/vim-easymotion", -- <Leader><Leader>f/L
	"andymass/vim-matchup", -- Better % matching

	-- TMUX
	"christoomey/vim-tmux-navigator",
	"preservim/vimux",
	"tyewang/vimux-jest-test", -- JavaScript tests
	"jtdowney/vimux-cargo", -- Rust tests
}

local opts = {
	install = {
		colorscheme = {
			"tokyonight-night",
		},
	},
}

require("lazy").setup(plugins, opts)

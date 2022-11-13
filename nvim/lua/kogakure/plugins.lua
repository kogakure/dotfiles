-- Packer.nvim – https://github.com/wbthomason/packer.nvim
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don’t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	max_jobs = 8,
	display = {
		open_fn = function()
			return require("packer.util").float({
				border = "rounded",
			})
		end,
	},
})

-- Plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins

	-- Colorscheme
	use("chriskempson/base16-vim") -- Base16 colorschemes
	use("folke/tokyonight.nvim") -- Tokyo Night color scheme
	use({ "catppuccin/nvim", as = "catppuccin" }) -- Catppuccin color scheme

	-- CMP
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- Buffer completions
	use("hrsh7th/cmp-path") -- Path completions
	use("hrsh7th/cmp-cmdline") -- Cmdline completions
	use("hrsh7th/cmp-nvim-lua") -- Lua API completions
	use("saadparwaiz1/cmp_luasnip") -- Snippet completions
	use("uga-rosa/cmp-dictionary") -- Dictionary completions
	use("f3fora/cmp-spell") -- Spell completions
	use("David-Kunz/cmp-npm") -- NPM package completions
	use("hrsh7th/cmp-nvim-lsp") -- LSP completions
	use("hrsh7th/cmp-nvim-lsp-signature-help") -- LSP Signature Help

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet Engine
	use("rafamadriz/friendly-snippets") -- A bunch of snippets

	-- LSP
	use("neovim/nvim-lspconfig") -- Enable LSP
	use("williamboman/mason.nvim") -- Manage LSP servers, DAP servers, linters, and formatters
	use("williamboman/mason-lspconfig.nvim") -- Bridge betwen Mason and lspconfig
	use("jose-elias-alvarez/null-ls.nvim") -- Inject LSP diagnostics, code actions, and more
	use("folke/trouble.nvim") -- Diagnostics
	use("creativenull/diagnosticls-configs-nvim") -- Collection of linters and formatters
	use("tamago324/nlsp-settings.nvim") -- LSP for json/yaml
	use({ "kosayoda/nvim-lightbulb", requires = "antoinemadec/FixCursorHold.nvim" })

	-- FZF
	use({ "junegunn/fzf", run = "./install --bin" })
	use("ibhagwan/fzf-lua")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("dhruvmanila/telescope-bookmarks.nvim") -- Open browser bookmarks
	use("nvim-telescope/telescope-file-browser.nvim") -- File and folder actions
	use("sudormrfbin/cheatsheet.nvim") -- Searchable cheatsheet
	use("nvim-telescope/telescope-node-modules.nvim") -- node_modules packages
	use("gbrlsnchs/telescope-lsp-handlers.nvim") -- LSP handlers
	use("crispgm/telescope-heading.nvim") -- Jump between headings
	use("nvim-telescope/telescope-fzy-native.nvim") -- FZY style sorter that is compiled
	use({ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } }) -- Frequency and recency
	use("nvim-telescope/telescope-github.nvim") -- GitHub CLI
	use("nvim-telescope/telescope-symbols.nvim") -- Symbols
	use("princejoogie/dir-telescope.nvim") -- Perform functions in selected directory

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("p00f/nvim-ts-rainbow") -- Rainbox parentheses
	use("nvim-treesitter/playground") -- Treesitter information in Neovim
	use("nvim-treesitter/nvim-treesitter-context") -- Show context

	-- DAP
	use("mfussenegger/nvim-dap") -- Debug Adapter Protocol

	-- File/Window Management
	use("ThePrimeagen/harpoon") --  Getting you where you want
	use("ThePrimeagen/git-worktree.nvim") -- Git Worktree
	use("lewis6991/gitsigns.nvim") -- Git decorations
	use("kyazdani42/nvim-web-devicons") -- Icons and colors for file types
	use("kyazdani42/nvim-tree.lua") -- A File Explorer
	use("akinsho/bufferline.nvim") -- Emulate tabs for buffers
	use("moll/vim-bbye") -- Delete buffers without closing the window
	use("akinsho/toggleterm.nvim") -- Terminal in Neovim
	use("nvim-lualine/lualine.nvim") -- Statusline
	use("norcalli/nvim-colorizer.lua") -- Highlight colors
	use("ahmedkhalf/project.nvim") -- Project Management
	use("lewis6991/impatient.nvim") -- Speed Up Startup
	use("lukas-reineke/indent-blankline.nvim") -- Indentation guides
	use("goolord/alpha-nvim") -- Customizable Greeter
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
	use("MattesGroeger/vim-bookmarks") -- Bookmarks
	use("folke/which-key.nvim") -- Display possible keybindings
	use("mrjones2014/legendary.nvim") -- Legend for keymaps, commands, and autocommands
	use("karb94/neoscroll.nvim") -- Smooth scrolling
	use("APZelos/blamer.nvim") -- Git Blame
	use("tpope/vim-fugitive") -- Git plugin
	use("elijahmanor/export-to-vscode.nvim") -- Export active Buffers to Visual Studio Code
	use("bogado/file-line") -- Jump directly to line in file with 'nvim index.html:20'
	use("ruanyl/vim-gh-line") -- Open current line in GitHub
	use("pwntester/octo.nvim") -- GitHub in Neovim
	use("nvim-pack/nvim-spectre") -- Search and replace
	use("stevearc/dressing.nvim") -- Improve the default vim.ui interfaces
	use("folke/zen-mode.nvim") -- Zen Mode (2)
	use("tpope/vim-eunuch") -- UNIX Shell commands
	use("folke/twilight.nvim") -- Dim inactive code
	use("ray-x/guihua.lua") -- Lua GUI lib
	use("ray-x/sad.nvim") -- Find & Replace
	use("gorbit99/codewindow.nvim") -- Minimap

	-- Editing Files
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("windwp/nvim-ts-autotag") -- Autoclose and autorename html tags
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("JoosepAlviste/nvim-ts-context-commentstring") -- Comment based on cursor location of file
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview" })
	use("yamatsum/nvim-cursorline") -- Highlight words and lines on the cursor
	use("mattn/emmet-vim") -- Emmet
	use("editorconfig/editorconfig-vim") -- Editorconfig
	use("sheerun/vim-polyglot") -- A collection of language packs (?)
	use("godlygeek/tabular") -- Align everything
	use("tpope/vim-abolish") -- Autofix spelling mistakes
	use("mg979/vim-visual-multi") -- Multi cursor mode
	use("vim-scripts/VisIncr") -- Increase and decreasing numbers, dates, daynames etc.
	use("tpope/vim-speeddating") -- Increase dates, times, etc.
	use("rstacruz/vim-xtract") -- Extract code into new file
	use("tpope/vim-repeat") -- Repeat plugins
	use("kylechui/nvim-surround") -- Surround selections, stylishly
	use("wuelnerdotexe/vim-astro") -- Astro support
	use("MunifTanjim/prettier.nvim") -- Prettier
	use("untitled-ai/jupyter_ascending.vim") -- Interact with jupyter_ascending
	use("rhysd/vim-grammarous") -- A powerful grammar checker for Vim using LanguageTool
	use("mechatroner/rainbow_csv") -- Rainbow CSV
	use("dbeniamine/cheat.sh-vim") -- Cheat.sh
	use("wakatime/vim-wakatime") -- Wakatime
	use("github/copilot.vim") -- GitHub Copilot

	-- Custom Text Objects
	use("christoomey/vim-titlecase")
	use("glts/vim-textobj-comment") -- ac, ic, aC
	use("jceb/vim-textobj-uri") -- au, iu, go
	use("kana/vim-textobj-datetime") -- ada, add, adf, adt, adz, ida, …
	use("kana/vim-textobj-user")
	use("michaeljsmith/vim-indent-object") -- ai, ii, aI, iI
	use("whatyouhide/vim-textobj-xmlattr") -- ax, ix
	use("nvim-treesitter/nvim-treesitter-textobjects") -- Syntax aware text-objects

	-- Custom Motions
	use("christoomey/vim-sort-motion") -- gs
	use("tommcdo/vim-exchange") -- cx, cxx, X, cxc
	use("easymotion/vim-easymotion") -- <Leader><Leader>f/L

	-- TMUX
	use("christoomey/vim-tmux-navigator")
	use("preservim/vimux")
	use("tyewang/vimux-jest-test") -- JavaScript tests
	use("jtdowney/vimux-cargo") -- Rust tests

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

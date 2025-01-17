-- Improved fzf.vim written in lua
-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"tomasky/bookmarks.nvim",
	},
	keys = {
		{ ";R", "<cmd>FzfLua oldfiles<cr>", desc = "Recently used" },
		{ ";a", "<cmd>FzfLua files --hidden<cr>", desc = "Find Files (hidden)" },
		{ ";b", "<cmd>FzfLua buffers previewer=false path_shorten=true winopts.height=0.4 winopts.width=0.6 winopts.row=0.4<cr>", desc = "Buffers" },
		{ ";cs", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell Suggest" },
		{ ";d", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
		{ ";f", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ ";m", "<cmd>lua require('fzf-lua').bookmarks({ path_shorten = true })<cr>", desc = "Bookmarks" },
		{ ";r", "<cmd>FzfLua resume<cr>", desc = "Resume" },
		{ "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ "<C-t>", "<cmd>FzfLua<cr>", desc = "Telescope" },
		{ "<M-p>", "<cmd>FzfLua files --hidden<cr>", desc = "Find Files (hidden)" },
	},
	config = function()
		local fzf = require("fzf-lua")
		local config = require("bookmarks.config").config

		local function get_text(annotation)
			local pref = string.sub(annotation, 1, 2)
			local ret = config.keywords[pref]
			if ret == nil then
				ret = config.signs.ann.text .. " "
			end
			return ret .. annotation
		end

		-- Register the custom bookmarks picker
		fzf.bookmarks = function(opts)
			opts = opts or {}

			-- Get bookmarks from cache
			local allmarks = config.cache.data
			local results = {}

			for filename, marks in pairs(allmarks) do
				local display_path = filename
				if opts.path_shorten then
					-- Get path relative to current working directory
					display_path = vim.fn.fnamemodify(filename, ":~:.")
				end

				for lnum, mark in pairs(marks) do
					local text = mark.a and get_text(mark.a) or mark.m
					table.insert(results, string.format("%s:%s:%s", display_path, lnum, text))
				end
			end

			-- Call fzf-lua with the collected data
			return fzf.fzf_exec(results, {
				prompt = "Bookmarks> ",
				actions = {
					["default"] = function(selected)
						local parts = vim.split(selected[1], ":", { plain = true })
						if parts[1] then
							-- Expand the path back to full path
							local full_path = vim.fn.fnamemodify(parts[1], ":p")
							-- Open file and jump to line
							vim.cmd("edit " .. vim.fn.fnameescape(full_path))
							if parts[2] then
								vim.cmd(parts[2])
							end
						end
					end,
				},
				previewer = true,
				fzf_opts = {
					["--delimiter"] = ":",
					["--with-nth"] = "1,2,3",
				},
			})
		end

		-- Setup fzf-lua with default options
		fzf.setup({
			winopts = {
				width = 0.90,
				height = 0.90,
				preview = {
					width = 0.5,
					horizontal = "right:50%",
				},
			},
		})
	end,
}

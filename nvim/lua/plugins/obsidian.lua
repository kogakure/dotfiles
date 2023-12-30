-- Obsidian
-- https://github.com/epwalsh/obsidian.nvim
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- required
    "nvim-lua/plenary.nvim",
    -- optional
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "junegunn/fzf",
    "junegunn/fzf.vim",
    "godlygeek/tabular",
    "preservim/vim-markdown",
  },
  opts = {
    workspaces = {
      {
        name = "zettelkasten",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Zettelkasten",
        overrides = {
          notes_subdir = "pages",
        },
      },
      {
        name = "highlights",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Highlights",
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
      new_notes_location = "current_dir",
      prepend_note_id = true,
      preprend_note_path = false,
      use_path_only = false,
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    disable_frontmatter = true,
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil and title ~= "" then
        suffix = title
      else
        suffix = tostring(os.date("%Y%m%d%H%M"))
      end
      return suffix
    end,
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
}

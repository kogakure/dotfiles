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
        -- "hrsh7th/nvim-cmp",
        -- "nvim-telescope/telescope.nvim",
        "ibhagwan/fzf-lua",
        "junegunn/fzf",
        "junegunn/fzf.vim",
        "godlygeek/tabular",
        "preservim/vim-markdown",
    },
    opts = {
        ui = { enable = false },
        workspaces = {
            {
                name = "zettelkasten",
                path = "~/Code/GitHub/obsidian/zettelkasten",
                overrides = {
                    notes_subdir = "pages",
                },
            },
            {
                name = "highlights",
                path = "~/Code/GitHub/obsidian/highlights",
            },
        },
        completion = {
            -- nvim_cmp = true,
            min_chars = 2,
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

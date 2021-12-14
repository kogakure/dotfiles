-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim/

local status, telescope = pcall(require, 'telescope')
if (not status) then return end

telescope.setup({
  defaults = {
    file_ignore_pattern = { 'yarn.lock' }
  },
  extensions = {
    lsp_handlers = {
      disable = {},
      location = {
        telescope = {},
        no_results_message = 'No references found',
      },
      symbol = {
        telescope = {},
        no_results_message = 'No symbols found',
      },
      call_hierarchy = {
        telescope = {},
        no_results_message = 'No calls found',
      },
      code_action = {
        telescope = require('telescope.themes').get_dropdown({}),
        no_results_message = 'No code actions available',
        prefix = '',
      },
    },
    bookmarks = {
      selected_browser = 'brave',
      url_open_command = 'open',
    }
  },
  fzf = {
    fuzzy = true,
    override_generic_sorter = false,
    override_file_sorter = true,
    case_mode = "smart_case"
  },
  buffers = {
    show_all_buffers = true,
    sort_lastused = true,
    -- theme = "dropdown",
    -- previewer = false,
    mappings = {
      i = {
        ["<M-d>"] = "delete_buffer",
      }
    }
  }
})

--- Extensions
require('telescope').load_extension('bookmarks')
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzf')
require('telescope').load_extension('harpoon')
require('telescope').load_extension('lsp_handlers')
require('telescope').load_extension('node_modules')

--- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<C-p>',         [[<Cmd>Telescope find_files<CR>]],                                                                   opts)
vim.api.nvim_set_keymap('n', '<Leader>b',     [[<Cmd>Telescope buffers<CR>]],                                                                      opts)
vim.api.nvim_set_keymap('n', '<Leader>bh',    [[<Cmd>Telescope bookmarks<CR>]],                                                                    opts)
vim.api.nvim_set_keymap('n', '<Leader>cheat', [[<Cmd>:Cheatsheet<CR>]],                                                                            opts)
vim.api.nvim_set_keymap('n', '<Leader>fb',    [[<Cmd>Telescope buffers<CR>]],                                                                      opts)
vim.api.nvim_set_keymap('n', '<Leader>fc',    [[<Cmd>Telescope git_status<CR>]],                                                                   opts)
vim.api.nvim_set_keymap('n', '<Leader>fcb',   [[<Cmd>Telescope git_branches<CR>]],                                                                 opts)
vim.api.nvim_set_keymap('n', '<Leader>ff',    [[<Cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>]],                         opts)
vim.api.nvim_set_keymap('n', '<Leader>fht',   [[<Cmd>Telescope help_tags<CR>]],                                                                    opts)
vim.api.nvim_set_keymap('n', '<Leader>fnm',   [[<Cmd>Telescope node_modules list<CR>]],                                                            opts)
vim.api.nvim_set_keymap('n', '<Leader>fr',    [[<Cmd>Telescope resume<CR>]],                                                                       opts)
vim.api.nvim_set_keymap('n', '<Leader>frg',   [[<Cmd>Telescope live_grep<CR>]],                                                                    opts)
vim.api.nvim_set_keymap('n', '<Leader>fs',    [[<Cmd>lua require('telescope.builtin').file_browser({ cwd = vim.fn.expand('%:p:h') })<CR>]],        opts)
vim.api.nvim_set_keymap('n', '<Leader>ft',    [[<Cmd>Telescope tags<CR>]],                                                                         opts)
vim.api.nvim_set_keymap('n', '<Leader>m',     [[<Cmd>Telescope marks<CR>]],                                                                        opts)
vim.api.nvim_set_keymap('n', '<Leader>km',    [[<Cmd>Telescope keymaps<CR>]],                                                                      opts)
vim.api.nvim_set_keymap('n', '<Leader>mru',   [[<Cmd>Telescope frecency<CR>]],                                                                     opts)
vim.api.nvim_set_keymap('n', '<Leader>ps',    [[<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep for > ') })<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>r',     [[<Cmd>Telescope live_grep<CR>]],                                                                    opts)
vim.api.nvim_set_keymap('n', '<Leader>t',     [[<Cmd>Telescope tags<CR>]],                                                                         opts)

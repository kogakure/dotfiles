local status, sidebar = pcall(require, 'sidebar-nvim')
if (not status) then return end

sidebar.setup()

--- Mappings
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ts', [[<Cmd>:SidebarNvimToggle<CR>]], opts)

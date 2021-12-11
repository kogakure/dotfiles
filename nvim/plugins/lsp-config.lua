-- lspconfig
-- https://github.com/neovim/nvim-lspconfig

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'gD',         [['<Cmd>lua vim.lsp.buf.declaration()<CR>']],                                opts)
vim.api.nvim_set_keymap('n', 'gd',         [['<Cmd>lua vim.lsp.buf.definition()<CR>']],                                 opts)
vim.api.nvim_set_keymap('n', 'K',          [['<Cmd>lua vim.lsp.buf.hover()<CR>']],                                      opts)
vim.api.nvim_set_keymap('n', 'gi',         [['<cmd>lua vim.lsp.buf.implementation()<CR>']],                             opts)
vim.api.nvim_set_keymap('n', '<C-k>',      [['<cmd>lua vim.lsp.buf.signature_help()<CR>']],                             opts)
vim.api.nvim_set_keymap('n', '<leader>wa', [['<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>']],                       opts)
vim.api.nvim_set_keymap('n', '<leader>wr', [['<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>']],                    opts)
vim.api.nvim_set_keymap('n', '<leader>wl', [['<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>']], opts)
vim.api.nvim_set_keymap('n', '<leader>D',  [['<cmd>lua vim.lsp.buf.type_definition()<CR>']],                            opts)
vim.api.nvim_set_keymap('n', '<leader>rn', [['<cmd>lua vim.lsp.buf.rename()<CR>']],                                     opts)
vim.api.nvim_set_keymap('n', 'gr',         [['<cmd>lua vim.lsp.buf.references()<CR>']],                                 opts)
vim.api.nvim_set_keymap('n', '<leader>e',  [['<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>']],               opts)
vim.api.nvim_set_keymap('n', 'Ä',          [['<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>']],                           opts)
vim.api.nvim_set_keymap('n', 'ä',          [['<cmd>lua vim.lsp.diagnostic.goto_next()<CR>']],                           opts)
vim.api.nvim_set_keymap('n', '<leader>q',  [['<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>']],                         opts)
vim.api.nvim_set_keymap('n', 'g0',         [[<Cmd>lua vim.lsp.buf.document_symbol()<CR>]],                              opts)
vim.api.nvim_set_keymap('n', 'gW',         [[<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>]],                             opts)
vim.api.nvim_set_keymap('n', 'ga',         [[<Cmd>lua vim.lsp.buf.code_action()<CR>]],                                  opts)

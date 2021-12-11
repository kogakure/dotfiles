-- nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter

local status, treesitter = pcall(require, 'nvim-treesitter')
if (not status) then return end

treesitter.setup {
  ensure_installed = {
    'bash',
    'css',
    'dockerfile',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'python',
    'ruby',
    'scss',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml',
  },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = true,
    disable = {},
  },
  context_commentstring = {
    enable = true
  }
}

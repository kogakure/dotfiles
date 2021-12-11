-- diagnosticls-configs-nvim
-- https://github.com/creativenull/diagnosticls-configs-nvim#setup

local status, dlsconfig = pcall(require, 'diagnosticls-configs')
if (not status) then return end

-- npm install -g diagnostic-languageserver eslint_d prettier_d_slim prettier
local eslint = require('diagnosticls-configs.linters.eslint')
local standard = require('diagnosticls-configs.linters.standard')
local prettier = require('diagnosticls-configs.formatters.prettier')
local prettier_standard = require('diagnosticls-configs.formatters.prettier_standard')

local function on_attach(client)
  print('Attached to ' .. client.name)
end

dlsconfig.init({
  default_config = true,
  format = true,
  on_attach = on_attach,
})

prettier.requiredFiles = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.toml',
  '.prettierrc.json',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.json5',
  '.prettierrc.js',
  '.prettierrc.cjs',
  'prettier.config.js',
  'prettier.config.cjs',
}

dlsconfig.setup({
  ['javascript'] = {
    linter = { eslint, standard },
    formatter = { prettier, prettier_standard },
  },
  ['javascriptreact'] = {
    linter = { eslint, standard },
    formatter = { prettier, prettier_standard }
  },
  ['css'] = {
    formatter = prettier
  },
  ['html'] = {
    formatter = prettier
  },
})


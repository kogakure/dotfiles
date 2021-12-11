-- nvim-lsp-installer
-- https://github.com/williamboman/nvim-lsp-installer

local status, lsp_installer = pcall(require, 'nvim-lsp-installer')
if (not status) then return end

local servers = {
  bashls = {},
  cssls = {},
  diagnosticls = {},
  dockerls = {},
  emmet_ls = {},
  eslint = {},
  graphql = {},
  html = {},
  jsonls = {},
  pyright = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim"},
        },
      },
    },
  },
  stylelint_lsp = {},
  svelte = {},
  tailwindcss = {},
  tsserver = {},
  vimls = {},
  vuels = {},
  yamlls = {},
}

lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    },
  },

  max_concurrent_installers = 4,
})

-- Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }

  if servers[server.name] then
    opts = servers[server.name]
  end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)

  vim.cmd([[do User LspAttachBuffers]])
end)

--- Global function to install servers automatically
function _G.lsp_install_sync()
  local lsp_installer_servers = require("nvim-lsp-installer.servers")

  local requested = {}
  for server_name, _ in pairs(servers) do
    local ok, server = lsp_installer_servers.get_server(server_name)
    if ok and not server:is_installed() then
      table.insert(requested, server_name)
    end
  end

  lsp_installer.install_sync(requested)
end

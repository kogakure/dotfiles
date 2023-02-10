-- Quickstart configs for Nvim LSP
-- https://github.com/neovim/nvim-lspconfig
return {
  "neovim/nvim-lspconfig",
  init = function()
    require("lazyvim.util").on_attach(function(_, buffer)
	  -- stylua: ignore
      vim.keymap.set("n", "g0", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = buffer, desc = "Document Symbols" })
    end)
  end,
  opts = {
    servers = {
      astro = {},
      cssls = {},
      cssmodules_ls = {},
      diagnosticls = {},
      emmet_ls = {},
      graphql = {},
      html = {},
      jsonls = {},
      sumneko_lua = {},
      svelte = {},
      tsserver = {},
      yamlls = {},
    },
  },
}

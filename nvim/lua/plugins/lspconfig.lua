-- Quickstart configs for Nvim LSP
-- https://github.com/neovim/nvim-lspconfig
return {
  "neovim/nvim-lspconfig",
  init = function()
    require("lazyvim.util").lsp.on_attach(function(_, buffer)
	  -- stylua: ignore
      vim.keymap.set("n", "g0", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = buffer, desc = "Document Symbols" })
      vim.keymap.set("n", "cc", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = buffer, desc = "Code Action" })
    end)
  end,
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      astro = {},
      cssls = {},
      cssmodules_ls = {},
      diagnosticls = {},
      emmet_ls = {},
      graphql = {},
      html = {},
      jsonls = {},
      lua_ls = {},
      svelte = {},
      tsserver = {},
      yamlls = {},
    },
  },
}

-- Package manager for LSP servers, DAP servers, linters, and formatters
-- https://github.com/williamboman/mason.nvim
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "astro-language-server",
      "cspell",
      "css-lsp",
      "cssmodules-language-server",
      "diagnostic-languageserver",
      "emmet-ls",
      "eslint_d",
      "html-lsp",
      "json-lsp",
      "lua-language-server",
      "prettier",
      "prettierd",
      "pyright",
      "shellcheck",
      "stylua",
      "svelte-language-server",
      "tailwindcss-language-server",
      "typescript-language-server",
      "vale",
      "yaml-language-server",
      "yamlfmt",
    },
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}

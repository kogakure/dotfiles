-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufNewFile" },
  keys = {
    {
      "<leader>mp",
      mode = { "n", "v" },
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end,
      desc = "Format file or range (in visual mode)",
    },
  },
  opts = {
    formatters = {
      eslint_d = {
        command = "eslint_d",
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
      },
    },
    formatters_by_ft = {
      astro = { "prettier" },
      css = { "prettier" },
      graphql = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier", "eslint_d" },
      javascriptreact = { "prettier", "eslint_d" },
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      svelte = { "prettier" },
      typescript = { "prettier", "eslint_d" },
      typescriptreact = { "prettier", "eslint_d" },
      yaml = { "prettier" },
      python = { "isort", "black" },
    },
  },
}

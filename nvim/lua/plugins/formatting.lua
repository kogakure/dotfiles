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
      -- ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
      astro = { { "prettierd", "prettier" } },
      css = { { "prettierd", "prettier" }, "stylelint" },
      fish = { "fish_indent" },
      graphql = { { "prettierd", "prettier" } },
      html = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" }, "eslint_d" },
      javascriptreact = { { "prettierd", "prettier" }, "eslint_d" },
      json = { { "prettierd", "prettier" } },
      lua = { "stylua" },
      markdown = { { "prettierd", "prettier" } },
      mdx = { { "prettierd", "prettier" } },
      python = { "isort", "black" },
      svelte = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" }, "eslint_d" },
      typescriptreact = { { "prettierd", "prettier" }, "eslint_d" },
      yaml = { { "prettierd", "prettier" } },
    },
  },
}

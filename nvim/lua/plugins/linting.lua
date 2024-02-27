-- Linting
-- https://github.com/mfussenegger/nvim-lint
return {
  "mfussenegger/nvim-lint",
  event = {
    "BufWritePre",
    "BufNewFile",
  },
  keys = {
    {
      "<leader>L",
      mode = { "n" },
      function()
        require("lint").try_lint()
      end,
      desc = "Trigger linting for current file",
    },
  },
  opts = {
    events = { "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      astro = { "eslint_d" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      python = { "pylint" },
      svelte = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },
  },
}

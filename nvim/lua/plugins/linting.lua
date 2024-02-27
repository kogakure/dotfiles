-- Linting
-- https://github.com/mfussenegger/nvim-lint
return {
  "mfussenegger/nvim-lint",
  event = {
    "BufWritePre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      astro = { "eslint_d" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      python = { "pylint" },
      svelte = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local lint_augrup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augrup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>L", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}

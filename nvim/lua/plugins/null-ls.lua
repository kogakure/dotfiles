return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      debug = false,
      debounce = 50,
      save_after_format = false,
      sources = {
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.diagnostics.cspell,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.diagnostics.tsc,
        null_ls.builtins.diagnostics.tsc,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylelint,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace,
      },
      root_dir = require("null-ls.utils").root_pattern("package.json", ".null-ls-root", ".neoconf.json", ".git"),
    })
  end,
}

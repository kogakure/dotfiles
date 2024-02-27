return {
  "nvimtools/none-ls.nvim",
  enabled = true,
  event = "LazyFile",
  dependencies = { "mason.nvim" },
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.root_dir = opts.root_dir
      or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.formatting.fish_indent,
      nls.builtins.diagnostics.fish,
      nls.builtins.diagnostics.eslint, -- TODO: How to get this feature in eslint-lsp?
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.shfmt,
    })
  end,
}

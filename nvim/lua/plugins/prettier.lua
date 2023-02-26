return {
  "MunifTanjim/prettier.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "jose-elias-alvarez/null-ls.nvim",
  },
  config = function()
    require("prettier").setup({
      bin = "prettierd",
      filetypes = {
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "svelte",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })
  end,
}

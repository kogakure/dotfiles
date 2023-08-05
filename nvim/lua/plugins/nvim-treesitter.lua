-- Nvim Treesitter configurations
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  depencendies = {
    "nvim-treesitter/playground",
  },
  opts = {
    indent = { enable = false },
    ensure_installed = {
      "astro",
      "bash",
      "css",
      "vimdoc",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
  },
}

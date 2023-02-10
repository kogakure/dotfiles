-- Nvim Treesitter configurations
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/playground",
  opts = {
    ensure_installed = {
      "astro",
      "bash",
      "css",
      "help",
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

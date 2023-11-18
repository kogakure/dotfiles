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
      "fish",
      "gitignore",
      "graphql",
      "html",
      "http",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "scss",
      "sql",
      "svelte",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Add custom filetypes
    vim.filetype.add({
      extension = {
        mdx = "mdx",
        rss = "rss",
      },
    })

    vim.treesitter.language.register("markdown", "mdx")
    vim.treesitter.language.register("xml", "rss")
  end,
}

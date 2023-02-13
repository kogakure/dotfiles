return {
  "laytan/tailwind-sorter.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  build = "cd formatter && npm i && npm run build",
  config = {
    on_save_pattern = { "*.html", "*.jsx", "*.tsx", "*.astro", "*.svelte" },
  },
}

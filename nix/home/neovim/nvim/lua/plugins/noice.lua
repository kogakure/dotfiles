-- Experimental UI plugin
-- https://github.com/folke/noice.nvim
return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
    },
    presets = {
      inc_rename = true,
      lsp_doc_border = true,
    },
  },
}

-- nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp

local status, cmp = pcall(require, 'cmp')
if (not status) then return end

cmp.setup({
  auto_select = false,
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-x>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
    ['<CR>'] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ select = false }),
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 3 },
    { name = 'npm', keyword_length = 4 },
    { name = 'ultisnips' },
  },
  formatting = {
    format = require('lspkind').cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        path = "[path]",
        luasnip = "[snip]"
      }
    }
  },
  experimental = {
    native_menu = false,
    ghost_text = true
  }
})

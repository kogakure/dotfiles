-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!yabai --restart-service",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!skhd --restart-service",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist]])
    vim.cmd([[SoftWrapMode]])
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "gitmux.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[tabdo wincmd =]])
  end,
})

vim.api.nvim_create_autocmd({ "User LspProgressStatusUpdated" }, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if not string.match(bufname, "COMMIT_EDITMSG") then
      require("lualine").refresh()
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.rss" },
  callback = function()
    vim.cmd([[set filetype=xml]])
  end,
})

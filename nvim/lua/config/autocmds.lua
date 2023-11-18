-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Reload tmux config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Reload gitmux config on save
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "gitmux.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

-- Restart yabai on config save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!yabai --restart-service",
})

-- Add specific settings for Markdown files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set wrap linebreak nolist]])
    vim.cmd([[SoftWrapMode]])
  end,
})

-- Evenly resize windows after resizing
vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[tabdo wincmd =]])
  end,
})

-- Turn off paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*" },
  command = "set nopaste",
})

-- Turn off lualine in Git commit messages
vim.api.nvim_create_autocmd({ "User LspProgressStatusUpdated" }, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if not string.match(bufname, "COMMIT_EDITMSG") then
      require("lualine").refresh()
    end
  end,
})

-- Change conceallevel for JSON files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

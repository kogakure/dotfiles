-- Open the link of current line on GitHub
-- https://github.com/ruanyl/vim-gh-line
return {
  "ruanyl/vim-gh-line",
  config = function()
    vim.g.gh_github_domain = "source.xing.com"
  end,
}

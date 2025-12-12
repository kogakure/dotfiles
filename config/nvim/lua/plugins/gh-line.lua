-- Open the link of current line on GitHub
-- https://github.com/ruanyl/vim-gh-line
-- <leader>gh (line) or <leader>gb (blame)
return {
	"ruanyl/vim-gh-line",
	config = function()
		vim.g.gh_github_domain = "github.com"
	end,
}

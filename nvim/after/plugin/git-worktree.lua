-- git-worktree.nvim – https://github.com/ThePrimeagen/git-worktree.nvim
local cmp_status_ok, worktree = pcall(require, "git-worktree")
if not cmp_status_ok then
	return
end

vim.g.git_worktree_log_level = "error"

worktree.setup()

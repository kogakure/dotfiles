-- Pop-up menu for code actions
-- https://github.com/weilbith/nvim-code-action-menu
return {
  "weilbith/nvim-code-action-menu",
  cmd = "CodeActionMenu",
  cond = vim.g.vscode == nil,
  keys = {
	-- stylua: ignore
    { "<leader>cc", "<cmd>CodeActionMenu<cr>", desc = "Code Action Menu" },
  },
}

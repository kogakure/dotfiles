-- Export active buffers to VS Code
-- https://github.com/elijahmanor/export-to-vscode.nvim
return {
  "elijahmanor/export-to-vscode.nvim",
  keys = {
	-- stylua: ignore
    { "<leader>code", function() require("export-to-vscode").launch() end, desc = "Export to VS Code" },
  },
}

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("kogakure.lsp.mason")
require("kogakure.lsp.handlers").setup()
require("kogakure.lsp.null-ls")
require("kogakure.lsp.trouble")
require("kogakure.lsp.lightbulb")

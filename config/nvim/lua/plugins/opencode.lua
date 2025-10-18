-- Integrate the opencode AI assistant with Neovim — streamline editor-aware research, reviews, and requests.
-- https://github.com/NickvanDyke/opencode.nvim
return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = {}, picker = {} } },
	},
	config = function()
		vim.g.opencode_opts = {}

		-- Required for `vim.g.opencode_opts.auto_reload`
		vim.opt.autoread = true

		-- Recommended/example keymaps
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask about this" })
		vim.keymap.set({ "n", "x" }, "<leader>os", function()
			require("opencode").select()
		end, { desc = "Select prompt" })
		vim.keymap.set({ "n", "x" }, "<leader>o+", function()
			require("opencode").prompt("@this")
		end, { desc = "Add this" })
		vim.keymap.set("n", "<leader>ot", function()
			require("opencode").toggle()
		end, { desc = "Toggle embedded" })
		vim.keymap.set("n", "<leader>oc", function()
			require("opencode").command()
		end, { desc = "Select command" })
		vim.keymap.set("n", "<leader>on", function()
			require("opencode").command("session_new")
		end, { desc = "New session" })
		vim.keymap.set("n", "<leader>oi", function()
			require("opencode").command("session_interrupt")
		end, { desc = "Interrupt session" })
		vim.keymap.set("n", "<leader>oA", function()
			require("opencode").command("agent_cycle")
		end, { desc = "Cycle selected agent" })
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("messages_half_page_up")
		end, { desc = "Messages half page up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("messages_half_page_down")
		end, { desc = "Messages half page down" })
	end,
}

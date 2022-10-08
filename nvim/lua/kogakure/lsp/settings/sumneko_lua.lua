return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "hs", "window", "pcall" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}

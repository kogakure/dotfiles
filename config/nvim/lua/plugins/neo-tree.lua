-- Neo-Tree
-- Neovim plugin to manage the file system and other tree like structures.
return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		window = {
			position = "right",
		},
	},
}

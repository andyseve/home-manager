-- neo-tree config

local present, neotree = pcall(require, "neo-tree")
if not present then
	return
end

neotree.setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
	},
	window = {
		position = "left",
		width = 30,
	},
})

require("setup.neotree")

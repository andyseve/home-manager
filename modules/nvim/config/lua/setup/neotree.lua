local utils = require("core.utils")

local toggle_neotree = function()
	vim.cmd("Neotree toggle")
	vim.cmd("stopinsert")
end

local mappings = {}
mappings.neotree = {
	whichkey = false,
	name = "פּ Neo-tree",
	n = {
		["<M-\\>"] = { toggle_neotree, "פּ Explorer" },
	},
	i = {
		["<M-\\>"] = { toggle_neotree, "פּ Explorer" },
	},
	v = {
		["<M-\\>"] = { toggle_neotree, "פּ Explorer" },
	}
}
mappings.windows = {
	name = " Windows",
	prefix = "<leader>w",
	n = {
		["w"] = { toggle_neotree, "פּ Explorer" },
	}
}

utils.load_mappings(mappings)

local utils = require("core.utils")

local function open_files()
	local ok, mf = pcall(require, "mini.files")
	if not ok then
		return
	end
	mf.open(vim.api.nvim_buf_get_name(0))
end

local function refresh_files()
	local ok, mf = pcall(require, "mini.files")
	if not ok then
		return
	end
	if mf.synchronize ~= nil then
		mf.synchronize()
	elseif mf.refresh ~= nil then
		mf.refresh()
	end
end

local mappings = {}
mappings.files = {
	whichkey = false,
	name = "פּ Files",
	n = {
		["<M-\\>"] = { open_files, "פּ Explorer" },
	},
	i = {
		["<M-\\>"] = { open_files, "פּ Explorer" },
	},
	v = {
		["<M-\\>"] = { open_files, "פּ Explorer" },
	}
}
mappings.windows = {
	name = " Windows",
	prefix = "<leader>w",
	n = {
		["w"] = { open_files, "פּ Explorer" },
		["r"] = { refresh_files, "פּ Refresh Explorer" },
	}
}

utils.load_mappings(mappings)

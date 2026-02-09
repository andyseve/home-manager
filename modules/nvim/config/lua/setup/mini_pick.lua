local utils = require("core.utils")

local function pick_builtin(name, fallback)
	local ok, pick = pcall(require, "mini.pick")
	if not ok then
		return
	end
	if pick.builtin ~= nil and pick.builtin[name] ~= nil then
		pick.builtin[name]()
	elseif fallback ~= nil then
		fallback()
	end
end

local mappings = {}
mappings.files = {
	name = " Files",
	prefix = "<leader>f",
	n = {
		["f"] = { function() pick_builtin("files") end, " Find files" },
		["r"] = { function() pick_builtin("oldfiles") end, " Recent files" },
		["g"] = { function() pick_builtin("grep_live") end, "Grep files" },
		["b"] = { function() pick_builtin("buffers") end, "﬘ Find buffers" },
		["h"] = { function() pick_builtin("help") end, " Help tags" },
	},
}
mappings.lists = {
	name = " Lists",
	prefix = "<leader>o",
	n = {
		["q"] = { function()
			pick_builtin("quickfix", function() vim.cmd("copen") end)
		end, " Quickfix" },
		["w"] = { function()
			pick_builtin("loclist", function() vim.cmd("lopen") end)
		end, " Loclist" },
		["g"] = { function() vim.cmd("digraphs") end, " Glyph" },
	}
}
mappings.diagnostics = {
	name = " Diagnostics",
	prefix = "<leader>d",
	n = {
		["i"] = { function()
			pick_builtin("diagnostic", function()
				vim.diagnostic.setqflist()
				vim.cmd("copen")
			end)
		end, " Diagnostics" },
		["m"] = { function()
			pick_builtin("notify", function() vim.cmd("messages") end)
		end, " Messages" },
	}
}

utils.load_mappings(mappings)

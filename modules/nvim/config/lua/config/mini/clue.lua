local MiniClue = require("mini.clue")
local utils = require("core.utils")

local clues = utils.get_mapping_clues()
local gen_clues = MiniClue.gen_clues

clues = vim.list_extend(clues, {
	gen_clues.builtin_completion(),
	gen_clues.g(),
	gen_clues.marks(),
	gen_clues.registers(),
	gen_clues.windows(),
	gen_clues.z(),
})

MiniClue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "<C-w>" },
	},
	clues = clues,
})

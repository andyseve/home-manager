require("mini.jump2d").setup()

local function jump_all()
	require("mini.jump2d").start()
end

vim.keymap.set({ "n", "x", "o" }, "s", jump_all, { desc = "Jump" })
vim.keymap.set("n", "S", jump_all, { desc = "Jump (all)" })

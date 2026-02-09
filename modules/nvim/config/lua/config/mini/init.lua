-- mini.nvim module loader

local user = require("core.user")

if not user.plugins.mini then
	return
end

local function safe_require(mod)
	local ok, err = pcall(require, mod)
	if not ok then
		vim.notify(string.format("mini config failed: %s", err), vim.log.levels.WARN)
	end
end

if user.plugins.mini_tabline then safe_require("config.mini.tabline") end
if user.plugins.mini_statusline then safe_require("config.mini.statusline") end
if user.plugins.mini_notify then safe_require("config.mini.notify") end
if user.plugins.mini_indentscope then safe_require("config.mini.indentscope") end
if user.plugins.mini_starter then safe_require("config.mini.starter") end
if user.plugins.mini_files then safe_require("config.mini.files") end
if user.plugins.mini_pick then safe_require("config.mini.pick") end
if user.plugins.mini_bufremove then safe_require("config.mini.bufremove") end
if user.plugins.mini_jump then safe_require("config.mini.jump") end
if user.plugins.mini_pairs then safe_require("config.mini.pairs") end
if user.plugins.mini_surround then safe_require("config.mini.surround") end
if user.plugins.mini_comment then safe_require("config.mini.comment") end
if user.plugins.mini_align then safe_require("config.mini.align") end
if user.plugins.mini_hipatterns then safe_require("config.mini.hipatterns") end
if user.plugins.mini_clue then safe_require("config.mini.clue") end

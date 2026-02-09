-- Author: Anish Sevekari
-- Last Modified: Fri 03 Mar 2023 03:21:17 PM EST
-- lsp config

local utils = require("core.utils")

-- keymaps (LspAttach)
local lsp_keymaps = function(event)
	local bufnr = event.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client ~= nil then
		local msg = string.format("Language server %s started!", client.name)
		utils.inspect(msg)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { callback = lsp_keymaps })

-- TODO: Add this into a mapping table.
-- keymap(bufnr, "n", "<leader>df", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
-- keymap(bufnr, "n", "<leader>di", "<cmd>LspInfo<cr>", opts)
-- keymap(bufnr, "n", "<leader>dI", "<cmd>LspInstallInfo<cr>", opts)
-- keymap(bufnr, "n", "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
-- keymap(bufnr, "n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
-- keymap(bufnr, "n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
-- keymap(bufnr, "n", "<leader>dr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
-- keymap(bufnr, "n", "<leader>ds", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- keymap(bufnr, "n", "<leader>dq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- key("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
-- key("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
-- key("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
-- key("n", "<leader>wl", function()
--print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--end, bufopts)

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

-- include capabilities provided by nvim_cmp
local present_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if present_cmp_nvim_lsp then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- lsp flags
local lsp_flags = {
	debounce_text_changes = 150,
}

-- language server settings

local servers = {
	ccls = {
		init_options = {
			compilationDatabaseDirectory = "build",
			index = { threads = 0 },
			clang = { excludeArgs = { "-frounding-math" } },
		},
	},
	hls = {},
	pyright = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				telemetry = { enable = false },
			},
		},
	},
	rust_analyzer = {},
}

for server, cfg in pairs(servers) do
	cfg.capabilities = capabilities
	cfg.flags = lsp_flags
	cfg.single_file_support = true
	vim.lsp.config(server, cfg)
end

vim.lsp.enable(vim.tbl_keys(servers))

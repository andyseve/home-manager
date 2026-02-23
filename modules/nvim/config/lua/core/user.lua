-- Author: Anish Sevekari
-- Last Modified: Tue 07 Mar 2023 06:21:50 AM EST
-- Contains user config - Makes it more readable than the plugin configuration files
-- Provides basic variables which determine multiple settings

-- @plugin contains list of plugins to use
-- @theme contains starting theme

local user = {}
user.plugins = {
	-- ui
	bufferline = false,
	lualine    = false,
	notify     = false,
	noice      = true,
	blankline  = false,
	whichkey   = false,
	zenmode    = true,
	gitsigns   = true,
	trouble    = true,
	twilight   = true,

	-- themes
	catppuccin = true,
	solarized  = true,
	onedark    = true,
	base16     = false,

	-- search and files
	telescope = false,
	nvimtree  = false,
	neotree   = true,
	undotree  = nil, -- use telescope plugin instead
	diffview  = true,

	-- syntax
	autopairs  = false,
	matchup    = false,
	surround   = false,
	colorizer  = false,
	treesitter = true,
	comment    = false,

	-- autocomplete and linting
	coc          = false,
	nvimcmp      = true,
	lsp          = true,
	lspsaga      = true,
	lspsignature = true,
	ultisnips    = true,
	luasnip      = false,


	-- filetype specifics
	tex = true,
	nix = true,

	-- utils
	tabular    = false,
	fast_fold  = false,
	bufdelete  = false,
	leap       = false,
	impatient  = true,
	toggleterm = true,
	alpha      = false,

	-- mini.nvim replacements
	mini           = true,
	mini_tabline   = true,
	mini_statusline = true,
	mini_notify    = true,
	mini_indentscope = true,
	mini_clue      = true,
	mini_starter   = true,
	mini_files     = false,
	mini_pick      = true,
	mini_bufremove = true,
	mini_jump      = true,
	mini_pairs     = true,
	mini_surround  = true,
	mini_comment   = true,
	mini_align     = true,
	mini_hipatterns = true,
}


if user.plugins.undotree == nil then
	user.plugins.undotree = not user.plugins.telescope
end

user.theme = "catppuccin"
user.use_catppuccin = true

return user

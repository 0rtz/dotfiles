local function trailing_whitespace()
	return vim.fn.search([[\s\+$]], 'nw') ~= 0 and 'TW' or ''
end

local lualine_theme_transparent = {
	normal = {
		a = { bg = 'None', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
	insert = {
		a = { bg = 'None', fg = '#00FF11', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
	visual = {
		a = { bg = 'None', fg = '#71b7ff', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
	replace = {
		a = { bg = 'None', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
	command = {
		a = { bg = 'None', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
	inactive = {
		a = { bg = 'None', gui = 'bold' },
		b = { bg = 'None', gui = 'bold' },
		c = { bg = 'None', gui = 'bold' },
		x = { bg = 'None', gui = 'bold' },
		y = { bg = 'None', gui = 'bold' },
		z = { bg = 'None', gui = 'bold' },
	},
}

require'lualine'.setup {
	options = {
		theme = lualine_theme_transparent,
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = { 'GV' },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				'filename',
			},
		},
		lualine_b = {
			{
				'branch',
			},
			{
				'diff',
				colored = true,
			},
		},
		lualine_c = {
			{
				'diagnostics',
				colored = true,
				sources = {'nvim_diagnostic'},
			},
			{
				trailing_whitespace,
			},
			{
				-- current language
				'vim.opt.keymap._value',
				cond = function()
					if vim.opt.keymap._value ~= "" then
					   return true
					end
				end,
				color = { fg = "#000000", bg = "#d50000" },
			},
			{
				'grepper#statusline',
				color = { fg = "#000000", bg = "#d50000" },
			},
		},
		lualine_x = {
			{
				'filetype',
				colored = true,
			},
		},
		lualine_y = {
			{
				"'%l:%c'",
			},
		},
		lualine_z = {
			{
				'filesize',
			},
			{
				"'LOC:%L'",
			},
		},
	},
	extensions = {'nvim-tree', 'fugitive', 'symbols-outline', 'trouble'},
}

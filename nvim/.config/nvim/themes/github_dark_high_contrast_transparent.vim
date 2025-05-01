lua <<EOF
-- modify github_dark_high_contrast to make it transparent
require('github-theme').setup({
	options = {
		transparent = true,
		styles = {
			comments = 'italic',
			keywords = 'bold',
			types = 'italic,bold',
		}
	},
	groups = {
		github_dark_high_contrast = {
			WinSeparator = { fg = "#43566F" },
			Visual = { fg = "#71b7ff", bg = none },
			Whitespace = { fg = "#ffffff" },
			Folded = { bg = "#211825" },
			-- transparency for status line, buffer line
			StatusLine = { bg = none },
			StatusLineNC = { bg = none },
			TabLineFill = { bg = none },
			-- highlight current line number
			CursorLineNr = { fg = "#d50000", bg = none, style = "bold" },
			-- show current function/condition/etc under cursor
			TreesitterContext = { bg = "#827390" },
			-- highlight unique characters on f/t
			QuickScopePrimary = { bg = "#d50000", style = "bold" },
			QuickScopeSecondary = { bg = "#dc00dc", style = "bold" },
			-- show indentation
			IblIndent = { fg = "#827390" },
			IblScope = { fg = "#BA69FF" },
			-- buffer line
			BufferLineIndicatorSelected = { fg = "#f0f3f6", style = "bold" },
			BufferLineBufferSelected = { fg = "#f0f3f6", style = "bold" },
			BufferLineBufferVisible = { fg = "#f0f3f6", style = "bold" },
			BufferLineTabSelected = { bg = "#43566F" },
			BufferLineTabSeparatorSelected = { fg = "#43566F", bg = "#43566F" },
			-- Finder/Telescope
			TelescopePreviewNormal = { bg = "#0A0C10" },
			TelescopeResultsNormal = { bg = "#181D26" },
			TelescopePromptNormal = { bg = "#0A0C10" },
			TelescopeSelection = { bg = "#2C3544" },
		},
	},
})
EOF

colorscheme github_dark_high_contrast

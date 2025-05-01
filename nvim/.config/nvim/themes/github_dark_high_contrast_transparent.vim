lua <<EOF
require('github-theme').setup({
	options = {
		styles = {
			comments = 'italic',
			keywords = 'bold',
			types = 'italic,bold',
		}
	},
	-- for changes to take effect interactively without restarting vim:
	-- setopt rmstarsilent && rm -f $HOME/.cache/nvim/github-theme/*
	-- OR
	-- :GithubThemeInteractive
	groups = {
		github_dark_high_contrast = {
			WinSeparator = { fg = "#43566F" },
			Visual = { fg = "#71b7ff", bg = none },
			Whitespace = { fg = "#ffffff" },
			Folded = { bg = "#211825" },
			-- transparency
			Normal = { bg = none },
			NormalNC = { bg = none },
			NonText = { bg = none },
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

local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

require('telescope').setup{
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-l>"] = actions.select_default,
				["<C-v>"] = { '<c-r>+',type = "command" },
				["<C-f>"] = actions.results_scrolling_down,
				["<C-b>"] = actions.results_scrolling_up,
				["<C-z>"] = actions.to_fuzzy_refine,
				["<C-p>"] = action_layout.toggle_preview,
				["<C-Space>"] = actions.toggle_selection,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<C-c>"] = actions.close,
				["<C-h>"] = "which_key",
				["<C-s>"] = require("telescope").extensions.hop.hop,
			},
			n = {
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<C-p>"] = action_layout.toggle_preview,
				["<C-s>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-l>"] = actions.select_default,
				["<C-Space>"] = actions.add_selection,
				["<esc>"] = actions.close,
				["<C-c>"] = actions.close,
			},
		},
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--hidden'
		},
		-- theme
		border = false,
		layout_strategy = "bottom_pane",
		layout_config = {
			bottom_pane = {
				height = 100,
				prompt_position = "bottom",
			},
		},
		prompt_prefix = "   ",
		selection_caret = "",
		entry_prefix = "",
		--------
	},

	pickers = {
		buffers = {
			mappings = {
				i = {
					["<C-b>"] = actions.delete_buffer,
				},
				n = {
					["<C-b>"] = actions.delete_buffer,
				},
			},
		},
		man_pages = {
			sections = { "ALL" },
		},
		git_branches = {
			mappings = {
				i = {
					["<CR>"] = actions.git_switch_branch,
					["<C-s>"] = require("telescope").extensions.hop.hop,
				},
				n = {
					["<CR>"] = actions.git_switch_branch,
					["<C-s>"] = require("telescope").extensions.hop.hop,
				},
			},
		},
	},

	extensions = {
		hop = {
			sign_hl = { "ErrorMsg", "ErrorMsg" },
		},
	}
}

-- compiled telescope sorter
require('telescope').load_extension('fzf')
-- jump to search entry
require('telescope').load_extension('hop')
-- notification manager
require('telescope').load_extension('notify')

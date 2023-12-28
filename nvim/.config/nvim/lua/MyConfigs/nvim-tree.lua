-- customise mappings
local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node, opts('Cd to directory'))
	vim.keymap.set('n', '<C-h>', api.tree.change_root_to_parent, opts('Cd to parent directory'))
	vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open in vertical split'))
	vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open in horizontal split'))
	vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open in new tab'))
	vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', '<C-[>', api.tree.change_root_to_parent, opts('CD'))
	vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
	vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Move to last file in directory'))
	vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('Move to first file in directory'))
	vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
	vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
	vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
	vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
	vim.keymap.set('n', 'r', api.fs.rename,	opts('Rename'))

	vim.keymap.set('n', 's', "<cmd>HopLine<CR>", opts('Jump to file'))
end

require'nvim-tree'.setup {
	view = {
		width = 40,
	},
	on_attach = on_attach,
	filters = {
		git_ignored = false,
		dotfiles = false,
		custom = {
			'node_modules',
			'.cache',
			'*.o',
		}
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	reload_on_bufenter = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	trash = {
		cmd = "trash-put",
		require_confirm = true,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	}
}

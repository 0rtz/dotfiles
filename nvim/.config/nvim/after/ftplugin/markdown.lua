local map = vim.keymap.set

map('n', 'K', '<nop>', { buffer = true })

-- Decrease/increase one leading '#' (if present) in visual selection
map('x', '-', ':s/^\\(#\\)\\{1,6}\\zs#//<CR>gv', { buffer = true })
map('x', '+', ':s/^\\(#\\{1,5}\\)/#\\1/<CR>gv', { buffer = true })

-- tpope/vim-surround
-- echo char2nr(" ")
-- Sb: bold
vim.b.surround_98 = "**\r**"
-- Si: italics
vim.b.surround_105 = "*\r*"
-- Sl: link
vim.b.surround_108 = "[[\r]]"

-- brianhuster/live-preview.nvim
map('n', '<leader>Fp', function ()
    vim.cmd("LivePreview close")
    vim.cmd("LivePreview start")
end, { buffer=true, desc="Preview markdown file" })

-- dhruvasagar/vim-table-mode
-- Enter '|' to create new row or align existing table
map('n', '<leader>Fa', ':TableModeRealign<CR>', { buffer = true, desc="Align table" })
map('n', '<leader>Ft', ':TableModeToggle<CR>', { buffer = true, desc="Toggle table mode" })
MyAddPlugin("akinsho/toggleterm.nvim")

-- Exit from vim terminal input prompt (to be able to scroll terminal as a vim buffer)
vim.keymap.set("t", "<c-]>", [[<c-\><c-n>]], { silent = true })

-- akinsho/toggleterm.nvim
require("toggleterm").setup({
  -- Ctrl+\ = toggle terminal window
  open_mapping = [[<c-\>]],
  terminal_mappings = true,
  insert_mappings = true,
})
-- Execute last shell command
vim.keymap.set("n", "<leader>z", [[:<c-u>TermExec go_back=0 cmd="!!"<CR>]])
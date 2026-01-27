-- GUI (neovide) configuration

if vim.g.neovide then

  vim.keymap.set("", "<m-g>", "<nop>")
  vim.keymap.set("", "<C-C>", '"+y')
  vim.keymap.set("", "<C-V>", '"+p')
  vim.keymap.set("c", "<C-V>", "<C-r>+")
  vim.keymap.set("i", "<C-V>", "<C-r>+")

  -- GUI window title
  vim.opt.title = true
  vim.opt.titlestring = "%<%F"
  vim.opt.guifont = "JetBrainsMonoNL NF:h16.5:#e-subpixelantialias:#h-slight"
  -- NOTE: turn off if crashes
  vim.g.neovide_refresh_rate = 144

end
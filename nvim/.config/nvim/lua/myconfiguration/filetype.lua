-- Filetype specific configuration meant to be run once (others in ftplugin/)

-- Set correct filetype for ansible files
MyAddPlugin("pearofducks/ansible-vim")
-- View rendered Markdown, HTML, AsciiDoc, SVG files in browser with live updates
MyAddPlugin("brianhuster/live-preview.nvim")
-- Render markdown files inside neovim
MyAddPlugin("MeanderingProgrammer/render-markdown.nvim")
-- Create tables in markdown
MyAddPlugin("dhruvasagar/vim-table-mode")

-- MeanderingProgrammer/render-markdown.nvim
require("render-markdown").setup({
  code = {
    disable_background = true,
    highlight_border = false,
  },
  heading = {
    width = "block",
  },
  sign = {
    enabled = false,
  },
  latex = {
    enabled = false,
  },
})
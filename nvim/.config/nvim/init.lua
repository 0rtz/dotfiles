require("my-plugin-manager") -- used by all modules, keep on top

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- LSP (Language Server Protocol)
require("myconfiguration.lsp")

-- Diagnostics
require("myconfiguration.diagnostics")

-- Treesitter
require("myconfiguration.treesitter")

-- Completion
require("myconfiguration.completion")

-- Git
require("myconfiguration.git")

-- Statusline
require("myconfiguration.statusline")

-- Tabs & Windows & Buffers
require("myconfiguration.buffers")

-- File explorer
require("myconfiguration.explorer")

-- Terminal
require("myconfiguration.terminal")

-- Editing
require("myconfiguration.editing")

-- Search
require("myconfiguration.search")

-- User Interface
require("myconfiguration.ui")

-- Filetype specific
require("myconfiguration.filetype")

-- GUI (neovide)
require("myconfiguration.gui")
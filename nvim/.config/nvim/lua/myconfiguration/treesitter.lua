-- Core treesitter features (syntax highlighting, folds, indentations) are built in Neovim

-- 'nvim-treesitter/nvim-treesitter' plugin only provides an ability to install/uninstall parsers
MyAddPlugin("nvim-treesitter/nvim-treesitter")
-- Show function/condition/etc. (context) under cursor
MyAddPlugin("nvim-treesitter/nvim-treesitter-context")
-- Highlight nested delimiters with different colors
MyAddPlugin("hiphish/rainbow-delimiters.nvim")

local map = vim.keymap.set

-- nvim-treesitter/nvim-treesitter
local treesitter = require('nvim-treesitter')

-- NOTE: do not autoinstall treesitter parsers because some of them actually have worse highlighting than default regex

-- Parsers list: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
-- Ensure these parsers are installed
local ensure_installed = {
  "c",
  "cmake",
  "markdown",
  "cpp",
  "css",
  "bash",
  "go",
  "groovy",
  "hyprlang",
  "ini",
  "java",
  "jq",
  "json",
  "regex",
  "rust",
  "ruby",
  "sql",
  "ssh_config",
  "vim",
  "vimdoc",
  "yaml",
  "zsh",
  "lua",
  "latex",
  "asm",
  "dockerfile",
  "python",
  "html",
  "http"
}

local installed = treesitter.get_installed('parsers')
local to_install = {}

for _, lang in ipairs(ensure_installed) do
  local is_installed = false
  for _, installed_lang in ipairs(installed) do
    if installed_lang == lang then
      is_installed = true
      break
    end
  end
  if not is_installed then
    table.insert(to_install, lang)
  end
end
if #to_install > 0 then
  -- Asynchronously install all missing parsers from 'ensure_installed'
  treesitter.install(to_install)
end

-- Treesitter functionality must be explicitly enabled for each buffer
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Only enable if parser is available for current filetype
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if not lang or not pcall(vim.treesitter.get_parser, 0, lang) then
      return
    end
    -- Syntax highlighting (provided by Neovim)
    vim.treesitter.start()
    -- Folds (provided by Neovim)
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
    -- Indentation (provided by nvim-treesitter, experimental)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

map("n", "<leader>ei", function()
  local view = vim.fn.winsaveview()
  -- '=' operator handled by "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.cmd([[normal! gg=G]])
  vim.fn.winrestview(view)
  vim.notify("Buffer reindented", vim.log.levels.INFO)
end, { desc = "Reindent whole buffer" })

-- nvim-treesitter/nvim-treesitter-context
map("n", ".c", function()
  require("treesitter-context").toggle()
end, {desc="Toggle treesitter context"})
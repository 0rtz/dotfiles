--   LSP
--   Linters
--   Neovim core
--   Custom tools
--         |
--         V
--   vim.diagnostic (UI layer)
--         |
--         V
--   Signs, virtual text, floats, lists

-- Asynchronous linter
MyAddPlugin("mfussenegger/nvim-lint")

-- Diagnostics UI
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  virtual_text = {
    source = true,
    prefix = "",
    severity = {
      min = vim.diagnostic.severity.INFO,
    },
    severity_sort = true,
  },
})

local map = vim.keymap.set

map("n", "[e", function()
  vim.diagnostic.jump({count=-1, float=true})
end, {desc = "Goto previous diagnostic"})

map("n", "]e", function()
  vim.diagnostic.jump({count=1, float=true})
end, {desc = "Goto next diagnostic"})

map("n", ".e", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, {desc = "Toggle diagnostics"})

map("n", "<leader>qe", vim.diagnostic.setqflist, {desc = "Diagnostics quickfix window"})
map("n", "<leader>ie", vim.diagnostic.open_float, {desc = "Show diagnostics under cursor"})

-- mfussenegger/nvim-lint
local lint = require("lint")
-- List of installed linters to enable
lint.linters_by_ft = {
  yaml = { "yamllint" },
  vim = { "vint" },
  markdown = { "markdownlint" },
  gitcommit = { "gitlint" },
}
-- Apply lints when opening new buffer and after saving buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    -- Apply enabled linters
    lint.try_lint()
    -- Apply this linter to all filetypes
    lint.try_lint("codespell")
  end,
})
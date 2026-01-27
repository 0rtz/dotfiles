-- 'neovim/nvim-lspconfig' plugin only provides preset configurations
-- (cmd, filetypes, root_dir, etc.) for already installed language servers
MyAddPlugin("neovim/nvim-lspconfig")
-- Code outline
MyAddPlugin("stevearc/aerial.nvim")

local map = vim.keymap.set

map("n", "gd", vim.lsp.buf.declaration, {desc = "Go to declaration"})
map("n", "gf", vim.lsp.buf.definition, {desc = "Go to definition"})
map("n", "glr", vim.lsp.buf.rename, {desc = "Rename"})
map("n", "gh", vim.lsp.buf.hover, {desc = "Show hover"})
map("n", "ga", vim.lsp.buf.code_action, {desc = "Show code actions"})

map("n", "<leader>il", function()
  vim.cmd("checkhealth vim.lsp")
end, {desc = "Show active language servers (take time to start)"})

map("n", "gr", function()
  local telescope_ok, _ = pcall(require, "telescope.builtin")
  if telescope_ok then
    vim.cmd("Telescope lsp_references")
  else
    vim.lsp.buf.references()
  end
end, {desc = "Show references"})

local installed = {
  "bashls",
  "yamlls",
  "ansiblels",
  "jsonls",
  "dockerls",
  "lua_ls",
  "marksman",
  "hyprls",
  "systemd_lsp",
}
-- Enable installed language servers in Neovim LSP builtin client with 'neovim/nvim-lspconfig' configurations
vim.lsp.enable(installed)

-- stevearc/aerial.nvim
require("aerial").setup({
  layout = {
    min_width = 45,
  },
  keymaps = {
    ["<CR>"] = "actions.jump",
    ["<Tab>"] = "actions.scroll",
    ["s"] = "<cmd>HopLine<CR>",
    ["h"] = "actions.right",
    ["l"] = "actions.left",
    ["H"] = "0",
    ["L"] = "$",
  },
  close_on_select = true,
})
map("n", ".s", ":AerialToggle<CR>", {desc = "Toggle code outline"})
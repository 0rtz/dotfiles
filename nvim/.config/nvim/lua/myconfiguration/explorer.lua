-- kyazdani42/nvim-tree.lua dependency
MyAddPlugin("kyazdani42/nvim-web-devicons")
-- File explorer tree
MyAddPlugin("kyazdani42/nvim-tree.lua")

local map = vim.keymap.set

-- Disable Neovim's built-in file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Auto change neovim root directory based on current LSP root and patterns
local root_patterns = {
  ".git",
  "_darcs",
  ".hg",
  ".bzr",
  ".svn",
  "package.json",
  ".root",
  ".marksman.toml",
}

local function find_root_by_pattern(start_path)
  local found = vim.fs.find(root_patterns, {
    path = start_path,
    upward = true,
  })
  if found and #found > 0 then
    -- pick deepest (first) match
    -- /home/user/project/.git
    -- /home/user/.git
    return vim.fs.dirname(found[#found])
  end
  return nil
end

local function get_lsp_root()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end
  return nil
end

local function set_root()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path == "" or vim.bo.buftype ~= "" then
    return
  end

  local dir = vim.fs.dirname(buf_path)

  -- Priority 1: LSP root
  local root = get_lsp_root()

  -- Priority 2: pattern-based root
  if not root then
    root = find_root_by_pattern(dir)
  end

  if root and root ~= vim.fn.getcwd() then
    vim.api.nvim_set_current_dir(root)
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("AutoRoot", { clear = true }),
  callback = set_root,
})

-- kyazdani42/nvim-tree.lua
local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  map("n", "<C-l>", api.tree.change_root_to_node, opts("Cd to directory"))
  map("n", "<C-h>", api.tree.change_root_to_parent, opts("Cd to parent directory"))
  map("n", "<C-v>", api.node.open.vertical, opts("Open in vertical split"))
  map("n", "<C-s>", api.node.open.horizontal, opts("Open in horizontal split"))
  map("n", "<C-t>", api.node.open.tab, opts("Open in new tab"))
  map("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
  map("n", "<C-[>", api.tree.change_root_to_parent, opts("CD"))
  map("n", "o", api.node.open.edit, opts("Open"))
  map("n", "<CR>", api.node.open.edit, opts("Open"))
  map("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
  map("n", "J", api.node.navigate.sibling.last, opts("Move to last file in directory"))
  map("n", "K", api.node.navigate.sibling.first, opts("Move to first file in directory"))
  map("n", "R", api.tree.reload, opts("Refresh"))
  map("n", "a", api.fs.create, opts("Create"))
  map("n", "c", api.fs.create, opts("Create"))
  map("n", "d", api.fs.trash, opts("Trash"))
  map("n", "r", api.fs.rename, opts("Rename"))
  map("n", "s", "<cmd>HopLine<CR>", opts("Jump to file"))
end
require("nvim-tree").setup({
  view = {
    width = 40,
  },
  on_attach = on_attach,
  filters = {
    git_ignored = false,
    dotfiles = false,
    custom = {
      "node_modules",
      ".cache",
      "*.o",
    },
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
  },
})
vim.keymap.set("n", ".n", function ()
  vim.cmd("NvimTreeFindFileToggle")
end, {desc="Toggle file explorer"})
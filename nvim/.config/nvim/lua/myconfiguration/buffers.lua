-- Preview quickfix window items
MyAddPlugin("kevinhwang91/nvim-bqf")

local map = vim.keymap.set

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

map("n", "<leader>h", ":bprevious<CR>", {desc="Switch to previous buffer"})
map("n", "<leader>l", ":bnext<CR>", {desc="Switch to next buffer"})
map("n", "<c-h>", ":e #<CR>", {desc="Switch to previously visited buffer"})

map("n", "<leader>d", function()
  vim.cmd('bwipeout')
end, {desc="Close current buffer"})

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, {desc="Close all buffers except current"})

map("n", "<leader>bh", function()
  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_bufs[vim.api.nvim_win_get_buf(win)] = true
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not visible_bufs[buf] and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, {desc="Close all buffers not visible in current window"})

map("n", "<leader>bn", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == '' then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, {desc="Close all buffers without names"})

local winmax_state = { active = false, restore_cmd = nil }
map("n", ".f", function()
  if winmax_state.active then
    vim.cmd(winmax_state.restore_cmd or "wincmd =")
    winmax_state.active = false
  else
    winmax_state.restore_cmd = vim.fn.winrestcmd()
    vim.cmd("wincmd | | wincmd _")
    winmax_state.active = true
  end
end, {desc="Toggle buffer maximize"})

map("n", "<C-w>1", "1gt", {desc="Go to tab 1"})
map("n", "<C-w>2", "2gt", {desc="Go to tab 2"})
map("n", "<C-w>3", "3gt", {desc="Go to tab 3"})
map("n", "<C-w>4", "4gt", {desc="Go to tab 4"})
map("n", "<C-w>5", "5gt", {desc="Go to tab 5"})
map("n", "<C-w>t", ":tab sp<cr>", {desc="Open in new tab"})
map("n", "<leader>D", ":tabclose<cr>", {desc="Close current tab"})
map("n", "<leader>tl", [[:<C-U>exec "tabm +" . (v:count1)<CR>]], {desc="Move tab right"})
map("n", "<leader>th", [[:<C-U>exec "tabm -" . (v:count1)<CR>]], {desc="Move tab left"})

augroup("my_last_tab", { clear = true })
autocmd("TabLeave", {
  group = "my_last_tab",
  callback = function()
    -- Tracks last tab for switching
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})
map("n", "<c-l>", [[:exe "tabn ".g:lasttab<cr>]], {desc="Go to previously visited tab"})

map("n", "[q", ":cprevious<CR>", {desc="Goto previous quickfix window item"})
map("n", "]q", ":cnext<CR>", {desc="Goto next quickfix window item"})

map("n", ".q", function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid ~= 0 then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end, {desc="Toggle quickfix window"})

-- kevinhwang91/nvim-bqf
---@diagnostic disable-next-line: missing-fields
require("bqf").setup({
  magic_window = false,
  func_map = {
    split = "<C-s>",
    vsplit = "<C-v>",
    prevfile = "<C-k>",
    nextfile = "<C-j>",
    pscrollup = "<C-u>",
    pscrolldown = "<C-d>",
    pscrollorig = "<C-o>",
    ptogglemode = ".f",
    stoggledown = "<C-space>",
    filter = "<C-q>",
  },
})
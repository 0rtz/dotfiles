-- Lightweight, powerful formatter
MyAddPlugin("stevearc/conform.nvim")
-- Automatically save buffer changes on modify
MyAddPlugin("okuuva/auto-save.nvim")
-- Set indentation style based on buffer content
MyAddPlugin("NMAC427/guess-indent.nvim")
-- Automatically insert corresponding pairs
MyAddPlugin("windwp/nvim-autopairs")
-- Draw ASCII diagrams
MyAddPlugin("jbyuki/venn.nvim")
-- Align text around selected characters
MyAddPlugin("junegunn/vim-easy-align")
-- Find and replace globally
MyAddPlugin("MagicDuck/grug-far.nvim")
-- Split/join blocks of code
MyAddPlugin("Wansmer/treesj")
-- Delete/change/add surrounding parentheses/quotes/etc.
MyAddPlugin("tpope/vim-surround")
-- Text objects for indentation level
MyAddPlugin("michaeljsmith/vim-indent-object")
-- Jump to words using keyboard
MyAddPlugin("smoka7/hop.nvim")
-- Preview buffer at a line number
MyAddPlugin("nacro90/numb.nvim")

local opt = vim.opt

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local map = vim.keymap.set

-- Expand tabs to spaces
opt.expandtab = true

-- Treat tab as 4 spaces by default
opt.tabstop = 4
opt.shiftwidth = 4

-- Disable mouse
opt.mouse = ""

-- Do not add <EOL> at the end of file if it does not exist
opt.fixeol = false

-- CTRL-D moves cursor to the first character on the line
opt.startofline = true

-- Do not wrap lines by default
opt.wrap = false

-- Do not close folds by default
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Time to wait mapped sequence to complete
opt.timeoutlen = 300

-- Disable annoying swap files
opt.swapfile = false

-- Use system clipboard register for everything
opt.clipboard = "unnamedplus"

--------------------------------------
-- Select (completion) mode keymaps --
--------------------------------------

map("s", "kj", "<esc>", {desc="Escape from select mode"})

--------------------------------------

-------------------------------
-- Command line mode keymaps --
-------------------------------

map("c", "<C-v>", "<c-r>+", {desc="Paste from system clipboard"})

-------------------------------

----------------------------------------------
-- Operators (c, d, y, etc...) mode keymaps --
----------------------------------------------

map("o", "H", "0", {desc="Move cursor to start of line"})
map("o", "L", "$", {desc="Move cursor to end of line"})

----------------------------------------------

-------------------------
-- Insert mode keymaps --
-------------------------

map("i", "kj", "<esc>", {desc="Escape from insert mode"})
map("i", "<C-p>", '<C-r>"', {desc="Paste from system clipboard"})
map("i", "<C-e>", "<C-o>$", {desc="Move cursor to end of line"})
map("i", "<C-l>", "<Right>", {desc="Move cursor one character right"})
map("i", "<C-h>", "<Left>", {desc="Move cursor one character left"})
map("i", "<C-v>", "<c-r>+", {desc="Paste from system clipboard"})

-------------------------

-------------------------
-- Visual mode keymaps --
-------------------------

map("v", "H", "0", {desc="Move cursor to start of line"})
map("v", "L", "$", {desc="Move cursor to end of line"})
map("v", "j", "gj", {desc="Move cursor one line down"})
map("v", "k", "gk", {desc="Move cursor one line up"})
map("v", ">", ">gv", {desc="Indent visual selection"})
map("v", "<", "<gv", {desc="Outdent visual selection"})

map("v", "<leader>d", '"_d', {desc = "Delete visual selection without copying"})

map("v", "<leader>ev", ":s/\\%V//g<left><left><left>", {desc = "Edit inside visual selection"})
map("v", "<leader>ef", '"zy:%s/<c-r>z//gc<left><left><left>', {desc = "Edit visual selection in file"})

map("v", "J", ":m '>+1<CR>gv", { desc = "Move selected blocks down" })
map("v", "K", ":m '<-2<CR>gv", { desc = "Move selected blocks up" })

local function convert_indentation(line1, line2, to_spaces)
  local original_expandtab = vim.bo.expandtab
  local retab_cmd = to_spaces and "retab" or "retab!"

  vim.bo.expandtab = to_spaces

  local ok, err = pcall(function()
    vim.cmd(("%d,%d%s"):format(line1, line2, retab_cmd))
  end)

  vim.bo.expandtab = original_expandtab

  if not ok then
    error(err)
  end
end

map("v", "<leader>ew", function()
  local line1 = vim.fn.line("'<")
  local line2 = vim.fn.line("'>")
  convert_indentation(line1, line2, true)
  -- Exit visual mode
  vim.api.nvim_input("<Esc>")
end, { desc = "Convert selected indentation to spaces" })

map("v", "<leader>et", function()
  local line1 = vim.fn.line("'<")
  local line2 = vim.fn.line("'>")
  convert_indentation(line1, line2, false)
  -- Exit visual mode
  vim.api.nvim_input("<Esc>")
end, { desc = "Convert selected indentation to tabs" })

-------------------------

-------------------------
-- Normal mode keymaps --
-------------------------

map("n", ".", "<nop>", {desc="Unmap"})
map("n", "*", "<nop>", {desc="Unmap"})
map("n", "#", "<nop>", {desc="Unmap"})
map("n", "<c-w>c", "<nop>", {desc="Unmap"})
map("n", "H", "0", {desc="Move cursor to start of line"})
map("n", "L", "$", {desc="Move cursor to end of line"})
map("n", "j", "gj", {desc="Move cursor one line down"})
map("n", "k", "gk", {desc="Move cursor one line up"})
map("n", "`", "@q", {desc="Execute macro q"})
map("n", "~", "@w", {desc="Execute macro w"})
map("n", ".w", ":set wrap!<CR>", {desc="Toggle line wrap"})
map("n", "<leader>X", ":qa<CR>", {desc="Quit Neovim"})
map("n", "<C-v>", '"+p', {desc="Paste from system clipboard"})

map("n", "<leader>y", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[normal! gg"+yG]])
  vim.fn.winrestview(view)
end, { desc = "Yank file content" })

map("n", "<leader>cn", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
  vim.notify(vim.fn.getreg("+") .. " copied")
end, {desc="Copy file name"})

map("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify(vim.fn.getreg("+") .. " copied")
end, {desc="Copy file path"})

map("n", "<leader>cr", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify(vim.fn.getreg("+") .. " copied")
end, {desc="Copy file relative path"})

map("n", "<leader>cd", function()
  vim.fn.setreg("+", vim.fn.expand("%:p:h"))
  vim.notify(vim.fn.getreg("+") .. " copied")
end, {desc="Copy file directory"})

map("n", "<leader>cg", function()
  vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. vim.fn.line("."))
  vim.notify(vim.fn.getreg("+") .. " copied")
end, {desc="Copy GDB line info"})

---------------------------

-- Open file at the last editing position
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lnum = mark[1]
    if lnum > 1 and lnum <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set filetype to text if not detected
augroup("my_default_ft", { clear = true })
autocmd("BufEnter", {
  group = "my_default_ft",
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "text"
    end
  end,
})

-- Ignore trailing whitespace characters in these buffer types
local ws_blacklist = { "diff", "git", "gitcommit", "qf", "help", "fugitive" }

vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#6F6565" })

local function highlight_whitespace()
  if vim.tbl_contains(ws_blacklist, vim.bo.filetype) then
    return
  end
  vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
  vim.fn.matchadd("TrailingWhitespace", [[ \+\ze\t]])
end

autocmd({ "BufWinEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("WhitespaceHighlight", { clear = true }),
  callback = highlight_whitespace,
})

autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("WhitespaceHighlightClear", { clear = true }),
  callback = function()
    vim.fn.clearmatches()
  end,
})

local function strip_whitespace()
  if vim.tbl_contains(ws_blacklist, vim.bo.filetype) then
    return
  end
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.cmd([[keeppatterns %s/ \+\ze\t//e]])
  vim.fn.winrestview(view)
end

map("n", "<leader>et", strip_whitespace, { desc = "Remove trailing whitespace characters" })
map("v", "<leader>eT", strip_whitespace, { desc = "Remove trailing whitespace characters" })

local function next_trailing_whitespace()
  vim.fn.search([[\s\+$\| \+\ze\t]], "w")
end
map("n", "]t", next_trailing_whitespace,
{ desc = "Goto next trailing whitespace character" })

local function prev_trailing_whitespace()
  vim.fn.search([[\s\+$\| \+\ze\t]], "bw")
end
map("n", "[t", prev_trailing_whitespace,
{ desc = "Goto previous trailing whitespace character" })

map({ "n", "i" }, "<C-n>", function()
  local is_english = vim.o.keymap == ""
  vim.o.keymap = is_english and "russian-jcukenwin" or ""
  vim.o.spelllang = is_english and "ru" or "en"

  if vim.fn.mode() == "i" then
    -- <C-o> temporarily leaves insert mode and comes back, which forces Neovim to reload the keymap
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-o>", true, false, true),
      "n",
      false
    )
  end
end, { desc = "Toggle language" })

-- stevearc/conform.nvim
local conform = require("conform")
vim.keymap.set("", "glf", function()
  conform.format({ async = true }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        -- leave visual mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end, { desc = "Format code" })

-- Enabled formatters
conform.setup({
  formatters_by_ft = {
    sh = { "shellharden" },
  },
})

vim.keymap.set("n", "glf", function()
  conform.format()
end)

-- okuuva/auto-save.nvim
require("auto-save").setup({
  execution_message = {
    -- Hide autosave message in cmdline
    message = "",
  },
})

-- NMAC427/guess-indent.nvim
require("guess-indent").setup({})

-- windwp/nvim-autopairs
require("nvim-autopairs").setup({
  -- Do not autoinsert pairs inside strings
  check_ts = true,
  ts_config = {
    { "string" },
  },
})

-- junegunn/vim-easy-align
map("x", "ga", "<Plug>(EasyAlign)", { remap = true })

-- MagicDuck/grug-far.nvim
map("n", "<leader>er", function()
  require("grug-far").open()
end, { desc = "Find and replace" })
map("v", "<leader>er", function()
  require("grug-far").with_visual_selection()
end, { desc = "Find and replace" })

-- Wansmer/treesj
map("n", "<leader>es", function()
  require("treesj").toggle()
end, { desc = "Split/join blocks of code" })

-- smoka7/hop.nvim
require("hop").setup() -- initialization required
map("n", "s", "<cmd>HopWord<CR>", { desc = "Jump to word" })
map("v", "s", "<cmd>HopWord<CR>", { desc = "Jump to word" })
map("n", "<C-s>", "<cmd>HopLine<CR>", { desc = "Jump to line" })
map("v", "<C-s>", "<cmd>HopLine<CR>", { desc = "Jump to line" })

-- nacro90/numb.nvim
require("numb").setup()

-- jbyuki/venn.nvim
map("n", ".v", function()
  local venn_enabled = vim.b.venn_enabled
  if not venn_enabled then
    vim.b.venn_enabled = true
    vim.opt.virtualedit = "all"
    -- Draw a line
    vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true, noremap = true })
    vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true, noremap = true })
    -- Draw a box
    vim.keymap.set("v", "b", ":VBox<CR>", { buffer = true, noremap = true })
    -- Draw a heavy box
    vim.keymap.set("v", "B", ":VBoxH<CR>", { buffer = true, noremap = true })
    -- Fill with color
    vim.keymap.set("v", "f", ":VFill<CR>", { buffer = true, noremap = true })
    vim.notify("Venn mode activated")
  else
    vim.opt.virtualedit = ""
    vim.cmd("mapclear <buffer>")
    vim.b.venn_enabled = nil
    vim.notify("Venn mode disabled")
  end
end, { desc = "Toggle venn diagram mode" })
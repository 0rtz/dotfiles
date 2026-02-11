-- Telescope dependency
MyAddPlugin("nvim-lua/plenary.nvim")
-- Telescope dependency
MyAddPlugin("kyazdani42/nvim-web-devicons")
-- Improve fuzzy search performance (optional Telescope dependency)
MyAddPlugin("nvim-telescope/telescope-fzf-native.nvim")
-- Ultimate Neovim search plugin
MyAddPlugin("nvim-telescope/telescope.nvim")
-- Search undo tree in Telescope
MyAddPlugin("debugloop/telescope-undo.nvim")
-- Search neovim tabs in Telescope
MyAddPlugin("LukasPietzschmann/telescope-tabs")
-- Highlight number of matched search instances (need this since hiding cmdline)
MyAddPlugin("kevinhwang91/nvim-hlslens")

local map = vim.keymap.set
local opt = vim.opt

-- Case-insensitive search
opt.ignorecase = true
opt.smartcase = true

-- If rg is installed use it for the ':grep' command
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --no-heading"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

map("v", "<leader>sn", '"hy/<c-r>h<CR>', {desc = "Forward search visual selection in buffer"})
map("n", "<leader>sn", "/<c-r><c-w><CR>", {desc="Forward search word under cursor in buffer"})
map("n", "<leader>sN", "?<c-r><c-w><CR>", {desc="Reverse search word under cursor in buffer"})
map("n", "<leader>sy", '/<c-r>"<CR>', {desc="Search clipboard content in file"})
map("n", "<leader>/", ":noh<CR>", {desc="Clear search highlight"})

-- nvim-telescope/telescope.nvim
local telescope = require("telescope")
local action_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.select_default,
        ["<C-v>"] = { "<c-r>+", type = "command" },
        ["<C-f>"] = actions.results_scrolling_down,
        ["<C-b>"] = actions.results_scrolling_up,
        ["<C-p>"] = action_layout.toggle_preview,
        ["<C-c>"] = actions.close,
      },
      n = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-l>"] = actions.select_default,
        ["<esc>"] = actions.close,
        ["<C-c>"] = actions.close,
      },
    },

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },

    border = false,
    layout_strategy = "bottom_pane",
    layout_config = {
      bottom_pane = {
        height = 100,
        prompt_position = "bottom",
      },
    },

    prompt_prefix = "",
    selection_caret = "",
    entry_prefix = "",
  },

  pickers = {
    buffers = {
      mappings = {
        i = { ["<C-b>"] = actions.delete_buffer },
        n = { ["<C-b>"] = actions.delete_buffer },
      },
    },
    man_pages = {
      sections = { "ALL" },
    },
  },
})

map("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--glob=!.git,--hidden,--files<cr>", {desc="Search files"})
map("n", "<leader>fF", "<cmd>Telescope find_files find_command=rg,--no-ignore,--glob=!.git,--hidden,--files<cr>", {desc="Search all files"})
map("n", "<leader>fa", "<cmd>Telescope current_buffer_fuzzy_find<cr>", {desc="Search buffer text"})
map("n", "<leader>fj", "<cmd>Telescope buffers<cr>", {desc="Search buffers"})
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {desc="Search help"})
map("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", {desc="Search man pages"})
map("n", "<leader>fq", "<cmd>Telescope quickfix<cr>", {desc="Search quickfix window"})
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", {desc="Search keymaps"})

map("n", "<leader>fn", function()
  require("telescope.builtin").find_files({ cwd = "~/notes", find_command = { "find", "-name", "*.md" } })
end, {desc="Search notes"})

map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", {desc="Search LSP symbols"})
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", {desc="Search LSP symbols global"})

map("n", "<leader>r", "<cmd>Telescope live_grep<cr>", {desc="Search text global"})

map("v", "<leader>r", function()
  -- Yank without affecting registers
  vim.cmd([[noau normal! "vy"]])
  local text = vim.fn.getreg("v")

  require("telescope.builtin").live_grep({
    default_text = text,
  })
end, { desc = "Search selected text global" })

map("n", "<leader>fp", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local qf_list = {}

  for lnum, line in ipairs(lines) do
    if line:match("^%s*//%s*Problem:") then
      table.insert(qf_list, { bufnr = bufnr, lnum = lnum, col = 1, text = line, })
    end
  end

  vim.fn.setqflist(qf_list)
  require("telescope.builtin").quickfix()

end, { desc = "Find all lines starting with: '// Problem:...'", silent = true })

-- nvim-telescope/telescope-fzf-native.nvim
telescope.load_extension("fzf")

-- debugloop/telescope-undo.nvim
telescope.load_extension("undo")
map("n", "<leader>fu", function()
  vim.cmd("Telescope undo")
end, { desc = "Search undo tree" })

-- LukasPietzschmann/telescope-tabs
telescope.load_extension("telescope-tabs")
map("n", "<leader>ft", function()
  vim.cmd("Telescope telescope-tabs list_tabs")
end, { desc = "Search tabs" })

-- kevinhwang91/nvim-hlslens
require("hlslens").setup()
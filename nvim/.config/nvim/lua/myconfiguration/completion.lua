-- Provides a popup completion menu, integrates with multiple sources (LSP, buffer text, etc.)
MyAddPlugin("hrsh7th/nvim-cmp")
-- nvim-cmp source for built-in LSP client
MyAddPlugin("hrsh7th/cmp-nvim-lsp")
-- nvim-cmp source for words in current buffer
MyAddPlugin("hrsh7th/cmp-buffer")
-- nvim-cmp source for file paths
MyAddPlugin("hrsh7th/cmp-path")
-- nvim-cmp source for vim's command line
MyAddPlugin("hrsh7th/cmp-cmdline")
-- nvim-cmp source for user provided dictionary
MyAddPlugin("uga-rosa/cmp-dictionary")
-- Snippet engine = define/expand/navigate code snippets
MyAddPlugin("L3MON4D3/LuaSnip")
-- nvim-cmp source for L3MON4D3/LuaSnip snippets engine
MyAddPlugin("saadparwaiz1/cmp_luasnip")
-- Collection of snippets for L3MON4D3/LuaSnip snippets engine
MyAddPlugin("rafamadriz/friendly-snippets")
-- Icons for each completion item
MyAddPlugin("onsails/lspkind-nvim")

local opt = vim.opt

-- Completion options
opt.updatetime = 100
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- 'hrsh7th/nvim-cmp'
local cmp = require("cmp")
-- 'onsails/lspkind-nvim'
local lspkind = require("lspkind")
-- 'L3MON4D3/LuaSnip'
local luasnip = require("luasnip")

-- Load 'rafamadriz/friendly-snippets' to 'L3MON4D3/LuaSnip'
require("luasnip.loaders.from_vscode").lazy_load()
-- Load my snippets to 'L3MON4D3/LuaSnip'
require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/luasnippets" })

cmp.setup({
  enabled = function()
    return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
  end,

  formatting = {
    format = lspkind.cmp_format({ mode = "symbol_text" }),
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-x>"] = cmp.mapping.abort(),
    -- Move to next completion suggestion
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end),
    -- Move to previous completion suggestion
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
    -- Select current completion suggestion
    ["<C-l>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = false }),
      c = function(fallback)
        if cmp.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({ select = true })
          end
        else
          fallback()
        end
      end,
    }),
  },

  -- Completion sources priority
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "dictionary", keyword_length = 2 },
  },
})

-- Completion in forward search
cmp.setup.cmdline("/", {
  mapping = {
    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
  },
  sources = { { name = "buffer" } },
})

-- Completion in normal Ex command
cmp.setup.cmdline(":", {
  mapping = {
    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
  },
  sources = { { name = "cmdline" } },
})

-- Completion in input() command
cmp.setup.cmdline("@", {
  mapping = {
    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
    ["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
  },
  sources = { { name = "path" } },
})

-- uga-rosa/cmp-dictionary
require("cmp_dictionary").setup({
  paths = { os.getenv("HOME") .. "/.config/nvim/en.dict" },
  exact_length = 2,
  first_case_insensitive = true,
})
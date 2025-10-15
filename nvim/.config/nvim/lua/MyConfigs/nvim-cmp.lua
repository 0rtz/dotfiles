local cmp = require('cmp')
-- Vscode-like icons for completion menu items
local lspkind = require('lspkind')
-- Insert code annotation
local neogen = require('neogen')
-- Snippets engine
local luasnip = require("luasnip")
-- Load 'rafamadriz/friendly-snippets'
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
	end,
	formatting = {
		format = lspkind.cmp_format({mode = 'symbol_text'})
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	-- Super-Tab like mapping: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
	mapping = {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			elseif neogen.jumpable() then
				neogen.jump_next()
			else
				fallback()
			end
		end),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			elseif neogen.jumpable() then
				neogen.jump_prev()
			else
				fallback()
			end
		end),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<C-x>"] = cmp.mapping.abort(),
		["<C-l>"] = cmp.mapping({
			i = cmp.mapping.confirm({ select = false }),
			c = function(fallback)
				if cmp.visible() then
					if luasnip.expandable() then
						luasnip.expand()
					else
						cmp.confirm({
							select = true,
						})
					end
				else
					fallback()
				end
			end
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{
			name = "dictionary",
			keyword_length = 2,
		},
	}
})

-- :getcmdtype() = get cmdline type
-- cmdline type specific configurations:
cmp.setup.cmdline('/', {
	mapping = {
		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'c' }),
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { 'c' }),
	},
	sources = { { name = "buffer" } } }
)
cmp.setup.cmdline(':', {
	mapping = {
		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'c' }),
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { 'c' }),
	},
	sources = { { name = "cmdline" } }
})
cmp.setup.cmdline('@', {
	mapping = {
		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'c' }),
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { 'c' }),
		["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { 'c' }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { 'c' }),
	},
	sources = { { name = "path" } }
})

-- Source for words in custom dictionary
local dict = {
	["*"] = { os.getenv("HOME").."/.config/nvim/en.dict" },
}
require("cmp_dictionary").setup({
	paths = dict["*"],
	exact_length = 2,
	-- ignore the case of the first character in dictionary
	first_case_insensitive = true,
})

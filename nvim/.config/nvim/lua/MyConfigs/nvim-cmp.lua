local cmp = require('cmp')
-- Vscode-like icons for completion menu items
local lspkind = require('lspkind')
-- Insert code annotation
local neogen = require('neogen')

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
	end,
	formatting = {
		format = lspkind.cmp_format({mode = 'symbol_text'})
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#jumpable"](1) == 1 then
				feedkey("<Plug>(vsnip-jump-next)", "")
			elseif neogen.jumpable() then
				neogen.jump_next()
			else
				fallback()
			end
		end),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
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
					cmp.confirm({ select = false })
				else
					fallback()
				end
			end
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
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

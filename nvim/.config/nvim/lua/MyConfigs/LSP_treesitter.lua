-- Language servers (lspconfig/mason/efm-langserver)
-- Highlights & Motions (treesitter)

-- Neovim logs :h lspconfig-logging
-- vim.lsp.set_log_level 'trace'

-- Currently configured languages:
	-- bash
	-- C/C++
	-- yaml
	-- json
	-- vim
	-- Dockerfile
	-- ansible
	-- xml
	-- .rst
	-- lua-nvim
	-- markdown
	-- zsh
	-- Makefile
	-- cmake
	-- gitcommit

-- Language servers configs used by the neovim LSP client
local lsp_conf = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- completions
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- buffer-scope LSP settings
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gf', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

	-- open in split
	buf_set_keymap('n', 'gF', '<Cmd>vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts)

	-- info about LSP symbol under cursor
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

	-- info about function parameters under cursor
	buf_set_keymap('n', 'gls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

	-- LSP formatting
	buf_set_keymap("n", "glf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
	buf_set_keymap("v", "glf", "<cmd>lua My_range_formatting()<CR>", opts)

	-- LSP diagnostics
	buf_set_keymap('n', '<leader>ie', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>qe', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
	buf_set_keymap('n', '\\d', '<cmd>lua My_toggle_diagnostics_buffer()<CR>', opts)
	buf_set_keymap('n', '\\D', '<cmd>lua My_toggle_diagnostics()<CR>', opts)
end

-- Language server diagnostic icons in signcolumn
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
-- Language server diagnostics virtual text
vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
		prefix = '',
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
		severity_sort = true,
	},
})

-- Language Servers package manager
-- NOTE: autoinstalls LSP setup with lsp_conf.$LSP.setup
require("mason").setup()
require("mason-lspconfig").setup {
	automatic_installation = { exclude = { "clangd" } }
}

-- which linters/formatters to use
local efmls_sources = {}

-- which languages treesitter support
local treesitter_sources = {}

-- Configured languages: ---------------------------------------------------------------------------

-- bash
efmls_sources.sh = {
	require('efmls-configs.formatters.shellharden'),
	require('efmls-configs.formatters.shfmt')
}
table.insert(treesitter_sources, "bash")
-- includes shellcheck linter support
lsp_conf.bashls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- C/C++
efmls_sources.c = {
	require('efmls-configs.linters.cppcheck')
}
efmls_sources.cpp = {
	require('efmls-configs.linters.cppcheck')
}
table.insert(treesitter_sources, "c")
table.insert(treesitter_sources, "cpp")
-- only use clangd executable installed on host
if vim.fn.executable("clangd") then
	local clangd_capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-16' },
	}
	lsp_conf.clangd.setup({
		on_attach = on_attach,
		capabilities = vim.tbl_deep_extend('keep', capabilities, clangd_capabilities),
		cmd = {'clangd', '--header-insertion=never'},
	})
end

-- yaml
efmls_sources.yaml = {
	require('efmls-configs.linters.yamllint'),
	require('efmls-configs.formatters.prettier')
}
table.insert(treesitter_sources, "yaml")
lsp_conf.yamlls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- json
efmls_sources.json = {
	require('efmls-configs.formatters.prettier'),
}
table.insert(treesitter_sources, "json")
table.insert(treesitter_sources, "json5")
table.insert(treesitter_sources, "jsonc")
lsp_conf.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	json = {
		-- validate some popular JSON document types
		schemas = require('schemastore').json.schemas(),
		validate = { enable = true },
	},
})

-- vim
efmls_sources.vim = {
	require('efmls-configs.linters.vint'),
}
table.insert(treesitter_sources, "vim")
lsp_conf.vimls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- Dockerfile
efmls_sources.dockerfile = {
	require('efmls-configs.linters.hadolint'),
}
table.insert(treesitter_sources, "dockerfile")
lsp_conf.dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- ansible
-- includes ansiblelint support
lsp_conf.ansiblels.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- xml
lsp_conf.lemminx.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- .rst
table.insert(treesitter_sources, "rst")
lsp_conf.esbonio.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- lua-nvim
table.insert(treesitter_sources, "lua")
lsp_conf.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT'
			},
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				-- library = vim.api.nvim_get_runtime_file("", true),
				library = {
					vim.env.VIMRUNTIME
				},
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		}
	}
})

-- markdown
table.insert(treesitter_sources, "markdown")
lsp_conf.marksman.setup({
	on_attach = on_attach,
	capabilities = capabilities
})
efmls_sources.markdown = {
	require('efmls-configs.linters.markdownlint'),
}

-- Makefile
table.insert(treesitter_sources, "make")

-- cmake
table.insert(treesitter_sources, "cmake")
-- includes cmake_format support
lsp_conf.cmake.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- gitcommit
table.insert(treesitter_sources, "gitcommit")
efmls_sources.gitcommit = {
	require('efmls-configs.linters.gitlint'),
}

-- all filetypes
efmls_sources['='] = {
	require('efmls-configs.linters.codespell'),
}

---------------------------------------------------------------------------

-- apply configured linters/formatters
lsp_conf.efm.setup {
	init_options = {documentFormatting = true},
	settings = {
		rootMarkers = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", ".root" },
		languages = efmls_sources,
	},
	on_attach = on_attach,
	capabilities = capabilities
}

-- treesitter specific sources
table.insert(treesitter_sources, "comment")
table.insert(treesitter_sources, "regex")
table.insert(treesitter_sources, "query")
table.insert(treesitter_sources, "diff")
-- remove duplicate elements from treesitter_sources
local seen_treesitter_sources = {}
for index,item in ipairs(treesitter_sources) do
	if seen_treesitter_sources[item] then
		table.remove(treesitter_sources, index)
	else
		seen_treesitter_sources[item] = true
	end
end
-- apply treesitter configurations
---@diagnostic disable-next-line: missing-fields
require'nvim-treesitter.configs'.setup {
	ensure_installed = treesitter_sources,
	sync_install = false,

	-- auto install parsers on buffer enter, needs tree-sitter cli
	auto_install = true,
	ignore_install = {},

	------------------------------
	-- treesitter built-in modules
	-- syntax highlighting for supppored treesitter_sources
	highlight = {
		enable = true,
		-- Follow anchors in preservim/vim-markdown
		additional_vim_regex_highlighting = {
			"markdown",
		},
	},
	-- '=' operator changes spaces to tabs where applicable
	indent = {
		enable = true
	},
	------------------------------

	------------------------------
	-- treesitter external modules

	-- andymass/vim-matchup
	-- better integration for %
	matchup = {
		enable = true,
	},

	-- nvim-treesitter-textobjects
	-- motions for LSP symbols
	textobjects = {
		-- operator-pending mode
		select = {
			enable = true,
			keymaps = {
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["il"] = "@loop.inner",
				["al"] = "@loop.outer",
				["ii"] = "@conditional.inner",
				["ai"] = "@conditional.outer",
				["ak"] = "@comment.outer",
				["ik"] = "@comment.inner",
				["ab"] = "@block.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]C"] = "@class.outer",
				["]F"] = "@function.outer",
				["]L"] = "@loop.outer",
				["]I"] = "@conditional.outer",
			},
			goto_next_end = {
				["]c"] = "@class.outer",
				["]f"] = "@function.outer",
				["]l"] = "@loop.outer",
				["]i"] = "@conditional.outer",
			},
			goto_previous_start = {
				["[c"] = "@class.outer",
				["[f"] = "@function.outer",
				["[l"] = "@loop.outer",
				["[i"] = "@conditional.outer",
			},
			goto_previous_end = {
				["[C"] = "@class.outer",
				["[F"] = "@function.outer",
				["[L"] = "@loop.outer",
				["[I"] = "@conditional.outer",
			},
		},
	},
	------------------------------
}

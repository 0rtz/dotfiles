scriptencoding utf-8

" {{{ Plugins initialization "

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute 'source ' . data_dir . '/autoload/plug.vim'
endif

call plug#begin()

" {{{ Colorschemes "

" Plug 'EdenEast/nightfox.nvim',
" Plug 'projekt0n/github-nvim-theme',
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" }}} Colorschemes "

" {{{ LSP (Language Server Protocol) "

" Default Nvim LSP client configurations for various LSP servers
Plug 'neovim/nvim-lspconfig'
" Language Servers package manager
Plug 'williamboman/mason.nvim'
" Autoinstalls Language Servers setup with nvim-lspconfig
Plug 'williamboman/mason-lspconfig.nvim',
" Validate some popular JSON/YAML document types
Plug 'b0o/schemastore.nvim'
" Preview of diagnostics
Plug 'folke/trouble.nvim'
" Show function signature during editing
Plug 'ray-x/lsp_signature.nvim'
" Show lightbulb when there is a code action available under cursor
Plug 'kosayoda/nvim-lightbulb'
" Rename LSP symbol under cursor
Plug 'smjonas/inc-rename.nvim'
" Class/symbols tree like viewer
Plug 'hedyhli/outline.nvim'

" }}} LSP (Language Server Protocol) "

" {{{ Treesitter "

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdateSync'}
" Show current function/condition/etc under cursor
Plug 'romgrk/nvim-treesitter-context'
" Insert code annotation
Plug 'danymat/neogen'
" Better folds
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'
" Semantic nested commenting
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Highlight parentheses with different colors
Plug 'hiphish/rainbow-delimiters.nvim'

" }}} Treesitter "

" {{{ Formatters "

Plug 'stevearc/conform.nvim'

" }}} Formatters "

" {{{ Linters "

Plug 'mfussenegger/nvim-lint'

" }}} Linters "

" {{{ Completion "

" Completion engine
Plug 'hrsh7th/nvim-cmp'
" Source for neovim's built-in language server client
Plug 'hrsh7th/cmp-nvim-lsp'
" Source for words in buffer
Plug 'hrsh7th/cmp-buffer'
" Source for filesystem paths
Plug 'hrsh7th/cmp-path'
" Source for vim's cmdline
Plug 'hrsh7th/cmp-cmdline'
" Source for words in custom dictionary
Plug 'uga-rosa/cmp-dictionary'
" Support for LSP/VSCode's snippet format (snippets engine)
Plug 'hrsh7th/vim-vsnip'
" Source for vim-vsnip
Plug 'hrsh7th/cmp-vsnip',
" Snippets collection
Plug 'rafamadriz/friendly-snippets'
" Vscode-like icons for completion menu items
Plug 'onsails/lspkind-nvim'

" }}} Completion "

" {{{ Git "

Plug 'tpope/vim-fugitive'
" Show git commit messages history under the cursor
Plug 'rhysd/git-messenger.vim'
" Show git log
Plug 'junegunn/gv.vim'
" Git hunks
Plug 'lewis6991/gitsigns.nvim'
" Tabpage for diffs preview
Plug 'sindrets/diffview.nvim'

" }}} Git "

" {{{ Finder/Telescope "

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" compiled telescope sorter
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" }}} Finder/Telescope "

" {{{ Status line "

Plug 'nvim-lualine/lualine.nvim'
" icons in statusline
Plug 'kyazdani42/nvim-web-devicons'

" }}} Status line "

" {{{ Tabs & Windows & Buffers "

" Buffer line
Plug 'akinsho/bufferline.nvim'
" Delete buffers based on conditions
Plug 'kazhala/close-buffers.nvim'
" Quickfix window helpers
Plug 'romainl/vim-qf'
" Better quickfix window
Plug 'kevinhwang91/nvim-bqf'
" Full screen mode
Plug 'folke/zen-mode.nvim'

" }}} Tabs & Windows & Buffers "

" {{{ File explorer "

Plug 'kyazdani42/nvim-tree.lua'
" Change cwd to lsp's root dir or pattern
Plug 'airblade/vim-rooter'

" }}} File explorer "

" {{{ Terminal "

Plug 'kassio/neoterm'

" }}} Terminal "

" {{{ Editing "

" Auto save buffer on edit
Plug 'Pocco81/auto-save.nvim'
" Guess buffer indentation
Plug 'NMAC427/guess-indent.nvim'
" Move visual selection up/down
Plug 'matze/vim-move'
" Automatically close parentheses
Plug 'windwp/nvim-autopairs'
" Draw diagrams
Plug 'jbyuki/venn.nvim'
" Strip trailing whitespaces
Plug 'ntpeters/vim-better-whitespace'
" Apply editorconfig coding styles as nvim options
Plug 'editorconfig/editorconfig-vim'
" Align text based on regex
Plug 'godlygeek/tabular'
" Surround with parentheses/quotes
Plug 'tpope/vim-surround'
" Additional text objects
Plug 'wellle/targets.vim'
" Additional text objects
Plug 'michaeljsmith/vim-indent-object'

" }}} Editing "

" {{{ Movement "

" Jump to word
Plug 'smoka7/hop.nvim'
" Jump to line number
Plug 'nacro90/numb.nvim'
" Open file at last editing position
Plug 'farmergreg/vim-lastplace'

" }}} Movement "

" {{{ Search "

" grep/rg wrappers
Plug 'mhinz/vim-grepper'
" Find definitions/references/usages without LSP
Plug 'pechorin/any-jump.vim'
" Show search matches count as virtual text
Plug 'kevinhwang91/nvim-hlslens'

" }}} Search "

" {{{ Info "

" Show available mappings
Plug 'folke/which-key.nvim'
" Highlight todo comments
Plug 'folke/todo-comments.nvim'
" Highlight word under cursor
Plug 'RRethy/vim-illuminate'
" Show indentation
Plug 'lukas-reineke/indent-blankline.nvim'
" Show colors of colorcodes
Plug 'norcalli/nvim-colorizer.lua'
" Undo visualizer
Plug 'simnalamburt/vim-mundo'
" Notification manager
Plug 'rcarriga/nvim-notify'

" }}} Info "

" {{{ filetype specific "

Plug 'tmux-plugins/vim-tmux'
Plug 'pearofducks/ansible-vim'
" Markdown tables align
Plug 'dhruvasagar/vim-table-mode'
" Markdown previewer in browser (hook does not work in nvim --headless)
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" }}} filetype specific "

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	lua vim.notify("Some modules are missing, running :PlugInstall", "INFO")
	PlugInstall --sync
endif

" }}} Plugins initialization "

" {{{ Options "

" Disable mouse
set mouse=
" Do not add <EOL> at the end of file if it does not exist
set nofixeol
" 24-bit RGB color in terminal
set termguicolors
" Highlight current line number with 'CursorLineNr'
set cursorline
set cursorlineopt=number
" Highlight current line number with 'CursorLineNr' in focused window only
augroup cursorline_set_group
	autocmd!
	autocmd BufEnter,FocusGained,WinEnter * set cursorline
	autocmd BufLeave,FocusLost,WinLeave   * set nocursorline
augroup END
" Display signs in the 'number' column
set signcolumn=number
" CTRL-D move cursor to the first character on the line
set startofline
" How to display whitespace characters in 'list' mode
set listchars+=trail:,eol:,space:,tab:├─┤
" Undo persistent history
set undofile
let &undodir = stdpath('data') . '/undohistory'
" Show line numbers
set number
" Show relative line numbers in focused window only
augroup my_numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set relativenumber   | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set norelativenumber | endif
augroup END
" If rg is installed use it for the ':grep' command
if executable('rg')
	set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" Treat tab as 4 spaces by default
set tabstop=4
set shiftwidth=4
" Do not wrap lines by default
set nowrap
" Set filetype to text if not detected
augroup my_default_ft
	autocmd!
	autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif
augroup END
" Do not close folds by default
set foldlevelstart=99

" }}} Options "

" {{{ Mappings "

let mapleader = "\<Space>"

" Select (completion) mode
smap c <BS>
smap kj <esc>

" Operators (c, d, y, etc...)
onoremap H 0
onoremap L $

" Visual mode
vnoremap H 0
vnoremap L $
vnoremap j gj
vnoremap k gk
vnoremap > >gv
vnoremap < <gv
vnoremap <leader>sn "hy/<c-r>h<CR>
" Search within visual selection
vnoremap <leader>f <Esc>/\%V
vnoremap <leader>y "+y
vnoremap <leader>d "_d
" Replace word in visual selection only
vnoremap <leader>er :s/\%V//g<left><left><left>
" Replace selection in a file
vnoremap <leader>R "zy:%s/<c-r>z//gc<left><left><left>
" Sort by line length
vnoremap <silent> <leader>es :! awk '{ print length(), $0 <Bar> "sort -n <Bar> cut -d\\  -f2-" }'<CR>
" Change indentation to spaces
function! s:Convert_To_Spaces() range
	if (&expandtab == 1)
		exe a:firstline . ',' . a:lastline . 'retab'
	else
		set expandtab
		exe a:firstline . ',' . a:lastline .  'retab'
		set noexpandtab
	endif
endfunction
vnoremap <leader>ew :call <SID>Convert_To_Spaces()<CR>
" Change indentation to tabs
function! s:Convert_To_Tabs() range
	if (&expandtab == 1)
		set noexpandtab
		exe a:firstline . ',' . a:lastline . 'retab!'
		set expandtab
	else
		exe a:firstline . ',' . a:lastline .  'retab!'
	endif
endfunction
vnoremap <leader>et :call <SID>Convert_To_Tabs()<CR>

" Insert mode
inoremap kj <esc>
inoremap <C-p> <C-r>"
inoremap <C-e> <C-o>$
inoremap <C-l> <Right>
inoremap <C-h> <Left>
inoremap <C-v> <c-r>+

" Command line mode
cnoremap <C-v> <c-r>+

" Normal mode
nnoremap H 0
nnoremap L $
nnoremap j gj
nnoremap k gk
nnoremap ` @q
nnoremap ~ @w
nnoremap .w :set wrap!<CR>
nnoremap .l :set rnu!<CR>:set number!<CR>
nnoremap .W :set colorcolumn=80
nnoremap . <nop>
nnoremap * <nop>
nnoremap # <nop>
nnoremap <c-w>c <nop>
nnoremap <silent> <leader>X :qa<CR>
nnoremap <silent> <leader>sn /<c-r><c-w><CR>
nnoremap <silent> <leader>sN ?<c-r><c-w><CR>
nnoremap <silent> <leader>sy /<c-r>"<CR>
nnoremap <silent> <expr> <leader>y 'gg"+yG'.( line(".") == 1 ? '' : '<C-o>')
nnoremap <leader>p "+p
nnoremap <C-v> "+p
nnoremap <silent> <leader>+ :<c-u>exec 'resize +'.v:count1*5<CR>
nnoremap <silent> <leader>_ :<c-u>exec 'resize -'.v:count1*5<CR>
nnoremap <silent> <leader>= :<c-u>exec 'vertical resize +'.v:count1*20<CR>
nnoremap <silent> <leader>- :<c-u>exec 'vertical resize -'.v:count1*20<CR>
nnoremap <silent> <leader>/ :noh<CR>
" Copy selected info to clipboard
nnoremap <silent> <leader>cn :let @+ = expand("%:t")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cp :let @+ = expand("%:p")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
" Relative to pwd
nnoremap <silent> <leader>cr :let @+ = expand("%")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cd :let @+ = expand("%:p:h")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cg :let @+ = @%.":".line('.')<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>
nnoremap <silent> <leader>vr :source $MYVIMRC <Bar> PlugClean <Bar> PlugInstall<CR>
nnoremap <silent> <leader>vu :PlugUpdate --sync
function! s:toggleLang()
	if (&keymap ==# '')
		set keymap=russian-jcukenwin
		set spelllang=ru
	else
		set keymap=
		set spelllang=en
	endif
endfunction
nnoremap <silent> <c-n> :call <SID>toggleLang()<CR>
inoremap <silent> <c-n> <C-o>:call <SID>toggleLang()<CR>

" }}} Mappings "

" {{{ Colorschemes "

function s:hl_groups_info()
	let tmpfile = tempname()
	exe 'redir > ' . tmpfile
	silent hi
	redir END
	exe 'tab new ' . tmpfile
	set filetype=txt
endfunction
nnoremap <leader>ih :Inspect<CR>
nnoremap <leader>iH :call <SID>hl_groups_info()<CR>

" NOTE: Uncomment plugin load before adding theme

" projekt0n/github-nvim-theme
":so $HOME/.config/nvim/themes/github_dark_high_contrast_transparent.vim

lua <<EOF
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color
})
EOF
colorscheme catppuccin

" }}} Colorschemes "

" {{{ LSP (Language Server Protocol) "

lua << EOF
vim.diagnostic.config({
	-- Language server diagnostic icons in signcolumn
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = ' ',
			[vim.diagnostic.severity.WARN] = ' ',
			[vim.diagnostic.severity.HINT] = ' ',
			[vim.diagnostic.severity.INFO] = ' ',
		},
	},
	-- Language server diagnostics virtual text
	virtual_text = {
		source = true,
		prefix = '',
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
		severity_sort = true,
	},
})

-- Language Servers package manager
require("mason").setup()
-- Autoinstalls Language Servers setup with nvim-lspconfig
-- call before vim.lsp.enable('$LANGUAGE_SERVER')
require("mason-lspconfig").setup()

-- Default Nvim LSP client configurations for various LSP servers:

-- bash
-- includes shellcheck linter support
vim.lsp.enable('bashls')

-- yaml
vim.lsp.enable('yamlls')
vim.lsp.config('yamlls', {
	settings = {
		yaml = {
			-- Validate some popular JSON/YAML document types
			-- https://github.com/b0o/SchemaStore.nvim
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- SchemaStore.nvim plugin and its advanced options like `ignore`.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require('schemastore').yaml.schemas(),
		},
	},
})

-- yaml.ansible
-- includes ansiblelint support
vim.lsp.enable('ansiblels')

-- json
vim.lsp.enable('jsonls')
vim.lsp.config('jsonls', {
	settings = {
		json = {
			-- Validate some popular JSON/YAML document types
			-- https://github.com/b0o/SchemaStore.nvim
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
})

-- vim
vim.lsp.enable('vimls')

-- dockerfile
vim.lsp.enable('dockerls')

-- lua
vim.lsp.enable('lua_ls')

-- markdown
vim.lsp.enable('marksman')

-- hyprlang
vim.lsp.enable('hyprls')
EOF

nnoremap <leader>il <cmd>LspInfo<CR>
nnoremap <leader>iL <cmd>Mason<CR>

nnoremap gd :lua vim.lsp.buf.declaration()<CR>
nnoremap gf :lua vim.lsp.buf.definition()<CR>
nnoremap gr :Telescope lsp_references<CR>
nnoremap gh :lua vim.lsp.buf.hover()<CR>
nnoremap ga :lua vim.lsp.buf.code_action()<CR>
nnoremap [e :lua vim.diagnostic.goto_prev()<CR>
nnoremap ]e :lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>qe :lua vim.diagnostic.setqflist()<CR>
" toggle diagnostics info
nnoremap .e :lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>

" Preview of diagnostics
lua << EOF
	require('trouble').setup {
		mode = "document_diagnostics",
		keys = {
			open_split = {"<c-s>"},
			open_vsplit = {"<c-v>"},
			close_folds = {"zc"},
			open_folds = {"zo"},
		},
	}
EOF
nnoremap ge <cmd>Trouble diagnostics toggle focus=true<cr>

" Show function signature during editing
lua << EOF
	require('lsp_signature').setup({
		hint_enable = false,
	})
EOF

" Show lightbulb when there is a code action available under cursor
lua << EOF
require("nvim-lightbulb").setup({
	autocmd = {
		enabled = true
	},
    ignore = {
        -- Filetypes to ignore.
        ft = {"markdown", "json"},
    },
})
EOF

" Rename LSP symbol under cursor
lua << EOF
require("inc_rename").setup()
EOF
nnoremap glr :IncRename 

" Class/symbols tree like viewer
lua << EOF
require("outline").setup({
	outline_window = {
		width = 45,
		relative_width = false,
	},
	keymaps = {
		close = {"<Esc>"},
		peek_location = "p",
		goto_and_close = {'<Enter>', 'o'},
		fold = "zc",
		unfold = "zo",
		fold_all = "zM",
		unfold_all = "zR",
	},
	symbol_folding = {
		-- Unfold all nodes on open
		autofold_depth = false,
	},
})
EOF
" NOTE: do not map to <Tab> since <Tab> and <C-i> are same in the terminal and extended key <C-i> does not work in tmux
nnoremap .s :Outline<CR>

" }}} LSP (Language Server Protocol) "

" {{{ Treesitter "

lua << EOF
require'nvim-treesitter.configs'.setup {
	-- Auto install parsers on buffer enter, needs tree-sitter cli
	auto_install = true,
	ignore_install = {},

	highlight = {
		enable = true,
		-- For the following filetypes: enable treesitter highlighting + vim builtin highlighting
		additional_vim_regex_highlighting = {
			-- "markdown",
		},
		-- Disable treesitter highlighting if these parsers are buggy
		-- disable = { "vim" },
	},

	-- '=' operator changes spaces to tabs where applicable
	indent = {
		enable = true
	},
}
EOF
" Use treesitter's = operator on whole buffer
nnoremap <silent> <expr> <leader>ei 'ggvG='.( line(".") == 1 ? '' : '<C-o>')

" Show current function/condition/etc under cursor
nnoremap .c :TSContextToggle<CR>

" Insert code annotation
lua << EOF
require('neogen').setup {
	enabled = true,
}
EOF
nnoremap <leader>eA :Neogen<CR>

" Better folds
lua <<EOF
-- Virtual text in folds: " line numbers"
local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ('  %d '):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, {chunkText, hlGroup})
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, {suffix, 'MoreMsg'})
	return newVirtText
end
require('ufo').setup({
	provider_selector = function(bufnr, filetype, buftype)
		return {'treesitter', 'indent'}
	end,
	fold_virt_text_handler = handler,
	open_fold_hl_timeout = 0,
})

EOF

" }}} Treesitter "

" {{{ Formatters "

lua <<EOF
conform = require("conform")

-- Format visual selection and leave visual mode
vim.keymap.set("", "glf", function()
  conform.format({ async = true }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end, { desc = "Format code" })

-- List of used formatters
conform.setup({
	formatters_by_ft = {
		sh = { "shellharden" },
	},
})
EOF
nnoremap glf :lua conform.format()<CR>

" }}} Formatters "

" {{{ Linters "

lua <<EOF
-- List of used linters
require('lint').linters_by_ft = {
	yaml = {'yamllint'},
	vim = {'vint'},
	dockerfile = {'hadolint'},
	markdown = {'markdownlint'},
	gitcommit = {'gitlint'},
}
-- Apply lints when opening new buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		-- Runs the linters defined in `linters_by_ft`
		require("lint").try_lint()
		-- Always run specific linter
		require("lint").try_lint("codespell")
	end,
})
-- Apply lints after saving buffer
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
		require("lint").try_lint("codespell")
	end,
})
EOF

" }}} Linters "

" {{{ Completion "

set updatetime=100
set completeopt=menu,menuone,noselect
set shortmess+=c
" Sync tabstop placeholder (multiple places snippets)
let g:vsnip_sync_delay = 0
let g:vsnip_choice_delay = 200
lua require('MyConfigs/nvim-cmp')

" }}} Completion "

" {{{ Git "

" tpope/vim-fugitive
nnoremap <leader>gs :Git<cr><C-w>T
nnoremap <leader>ga :Gwrite<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>qd :Git difftool<cr>
nnoremap <leader>gd :tab Git diff<cr>
nnoremap <leader>gh :tab Git diff HEAD~1 HEAD<cr>
augroup my_fugitive_new_maps
	autocmd!
	autocmd FileType fugitive call <SID>SetFugitiveMaps()
	function s:SetFugitiveMaps()
		" Diff new Tab
		nmap <buffer> dt dp<C-w>T
		" Diff Preview
		nmap <buffer> dd dp
	endfunction
augroup END

" Show git commit messages history under the cursor
" o = older. Back to older commit at the line
let g:git_messenger_no_default_mappings = v:true
nnoremap <leader>gL :GitMessenger<cr>

" Show git log
nnoremap <leader>gl :GV --max-count=1000<cr>

" Git hunks
lua << EOF
require('gitsigns').setup {
	-- keybindings
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map('n', ']h', function() gitsigns.nav_hunk('next') end)
		map('n', '[h', function() gitsigns.nav_hunk('prev') end)
		map('v', '<leader>g', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
		map('v', '<leader>G', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
		map('n', '<leader>gp', gitsigns.preview_hunk)
	end
}
EOF

" Tabpage for diffs preview
lua << EOF
local cb = require'diffview.config'.diffview_callback
require('diffview').setup ({
	keymaps = {
		view = {
			[".n"] = cb("toggle_files"),
		},
		file_panel = {
			[".n"] = cb("toggle_files"),
			["s"]  = "<cmd>HopLine<CR>",
			["a"]  = cb("toggle_stage_entry"),
		},
	},
})
EOF
nnoremap <leader>gD :DiffviewOpen<cr>

" }}} Git "

" {{{ Finder/Telescope "

nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--glob=!.git,--hidden,--files<cr>
nnoremap <leader>fF <cmd>Telescope find_files find_command=rg,--no-ignore,--glob=!.git,--hidden,--files<cr>
nnoremap <leader>fr <cmd>Telescope live_grep<cr>
nnoremap <leader>fa <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>
nnoremap <leader>fj <cmd>Telescope jumplist<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <leader>fn <cmd>lua require('telescope.builtin').find_files({cwd = "~/.notes", find_command = { "find", "-name", "*.md" }})<cr>
nnoremap <leader>fl <cmd>Telescope lsp_dynamic_workspace_symbols<cr>

lua <<EOF
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')
require('telescope').setup{
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-l>"] = actions.select_default,
				["<C-v>"] = { '<c-r>+',type = "command" },
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
		-- Allows livegrep to search in all files starting from current cwd
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--hidden'
		},
		-- Theme
		border = false,
		layout_strategy = "bottom_pane",
		layout_config = {
			bottom_pane = {
				height = 100,
				prompt_position = "bottom",
			},
		},
		prompt_prefix = "   ",
		selection_caret = "",
		entry_prefix = "",
		--------
	},

	pickers = {
		buffers = {
			mappings = {
				i = {
					["<C-b>"] = actions.delete_buffer,
				},
				n = {
					["<C-b>"] = actions.delete_buffer,
				},
			},
		},
		man_pages = {
			sections = { "ALL" },
		},
	},
}
-- Compiled telescope sorter
require('telescope').load_extension('fzf')
EOF

" }}} Finder/Telescope "

" {{{ Statusline "

lua require('MyConfigs/statusline')

" }}} Statusline "

" {{{ Tabs & Windows & Buffers "

nnoremap <silent><leader>1 1gt
nnoremap <silent><leader>2 2gt
nnoremap <silent><leader>3 3gt
nnoremap <silent><leader>4 4gt
nnoremap <silent><leader>5 5gt
nnoremap <silent><leader>6 6gt
nnoremap <silent><leader>7 7gt
nnoremap <silent><leader>8 8gt
nnoremap <silent><leader>9 9gt
nnoremap <C-w>t :tab sp<cr>
nnoremap <leader>tL :<C-U>exec "tabm +" . (v:count1)<CR>
nnoremap <leader>tH :<C-U>exec "tabm -" . (v:count1)<CR>
augroup my_last_tab
	au!
	au TabLeave * let g:lasttab = tabpagenr()
augroup END
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
nnoremap <silent> <c-h> :e #<CR>
nnoremap <leader>D :tabclose<cr>

" Buffer line
lua << EOF
require("bufferline").setup {
	options = {
		-- Buffer close icon
		show_buffer_close_icons = false,
		-- Tab close icon
		close_icon = '',
		indicator = {
			icon = '󰁚',
			style = 'icon',
		},
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "center",
			},
			{
				filetype = "nnn",
				text = "File Explorer",
				text_align = "center",
			},
			{
				filetype = "Outline",
				text = "Class viewer",
				text_align = "center",
			},
		},
	},
}
EOF
nnoremap <silent> gb :BufferLinePick<CR>
nnoremap <silent> gB :BufferLinePickClose<CR>
nnoremap <silent> <leader>h :BufferLineCyclePrev<CR>
nnoremap <silent> <leader>l :BufferLineCycleNext<CR>
nnoremap <silent> <leader>H :BufferLineMovePrev<CR>
nnoremap <silent> <leader>L :BufferLineMoveNext<CR>
nnoremap <silent> <leader>bp :BufferLineTogglePin<CR>

" Delete buffers based on conditions
nnoremap <silent> <leader>d :BWipeout! this<CR>
nnoremap <silent> <leader>bo :BWipeout other<CR>
nnoremap <silent> <leader>bh :BWipeout hidden<CR>
nnoremap <silent> <leader>bn :BWipeout nameless<CR>

" Quickfix window helpers
nmap [q <Plug>(qf_qf_previous)
nmap ]q  <Plug>(qf_qf_next)
nmap .q <Plug>(qf_qf_toggle)
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0

" Better quickfix window
lua << EOF
require('bqf').setup({
	magic_window = false,
	func_map = {
		split = '<C-s>',
		vsplit = '<C-v>',
		prevfile = '<C-k>',
		nextfile = '<C-j>',
		pscrollup = '<C-u>',
		pscrolldown = '<C-d>',
		pscrollorig = '<C-o>',
		ptogglemode = '.f',
		stoggledown = '<C-space>',
		filter = '<C-q>'
	},
})
EOF

" Full screen mode
nnoremap .f :ZenMode<CR>
lua << EOF
require("zen-mode").setup({
	plugins = {
        options = {
			laststatus = 0,
		},
		gitsigns = { enabled = true },
	},
})
EOF

" }}} Tabs & Windows & Buffers "

" {{{ File explorer "

lua <<EOF
-- customise mappings
local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node, opts('Cd to directory'))
	vim.keymap.set('n', '<C-h>', api.tree.change_root_to_parent, opts('Cd to parent directory'))
	vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open in vertical split'))
	vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open in horizontal split'))
	vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open in new tab'))
	vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', '<C-[>', api.tree.change_root_to_parent, opts('CD'))
	vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
	vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Move to last file in directory'))
	vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('Move to first file in directory'))
	vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
	vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
	vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
	vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
	vim.keymap.set('n', 'r', api.fs.rename,	opts('Rename'))
	vim.keymap.set('n', 's', "<cmd>HopLine<CR>", opts('Jump to file'))
end

require'nvim-tree'.setup {
	view = {
		width = 40,
	},
	on_attach = on_attach,
	filters = {
		git_ignored = false,
		dotfiles = false,
		custom = {
			'node_modules',
			'.cache',
			'*.o',
		}
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
	}
}
EOF
nnoremap .n :NvimTreeFindFileToggle<CR>

" Change cwd based on pattern
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json',
			\'.root', '.marksman.toml' ]
let g:rooter_ignore = 1
let g:rooter_silent_chdir = 1

" }}} File explorer "

" {{{ Terminal "

let g:neoterm_default_mod = 'botright'
let g:neoterm_autojump = 1
let g:neoterm_autoinsert = 1
" Execute command mapped on <leader>zm
let g:neoterm_automap_keys = '<Space>zz'
nnoremap .z :<c-u>exec v:count.'Ttoggle'<cr>
" Exit from vim terminal input prompt
tnoremap <silent> <c-\> <c-\><c-n>
nnoremap <leader>zm :Tmap clear;
nnoremap <leader>zx :<c-u>exec v:count.'Tclose!'<cr>

" }}} Terminal "

" {{{ Editing "

" Auto save buffer on edit
lua <<EOF
require("auto-save").setup({
	execution_message = {
		message = "",
	}
})
EOF

" Guess buffer indentation
lua << EOF
require('guess-indent').setup {}
EOF

" Move visual selection up/down
let g:move_map_keys = 0
vmap K <Plug>MoveBlockUp
vmap J <Plug>MoveBlockDown

" Automatically close parentheses
lua <<EOF
require('nvim-autopairs').setup{
	map_c_w = true,
	check_ts = true,
	ts_config = {
		{'string'},
	},
	disable_filetype = { "TelescopePrompt" },
}
EOF

" Draw diagrams
nnoremap <silent> .v :lua Toggle_venn()<CR>
lua <<EOF
function _G.Toggle_venn()
	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	if venn_enabled == "nil" then
		vim.b.venn_enabled = true
		vim.cmd[[setlocal ve=all]]
		-- draw a line
		vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
		-- draw a box
		vim.api.nvim_buf_set_keymap(0, "v", "b", ":VBox<CR>", {noremap = true})
		-- draw a heavy box
		vim.api.nvim_buf_set_keymap(0, "v", "B", ":VBoxH<CR>", {noremap = true})
		-- fill with color
		vim.api.nvim_buf_set_keymap(0, "v", "f", ":VFill<CR>", {noremap = true})
		MyNotificationMin("virtualedit mode actviated")
	else
		vim.cmd[[setlocal ve=]]
		vim.cmd[[mapclear <buffer>]]
		vim.b.venn_enabled = nil
		MyNotificationMin("virtualedit mode disabled")
	end
end
EOF

" Strip trailing whitespaces
let g:better_whitespace_enabled=1
let g:better_whitespace_filetypes_blacklist=['diff', 'git', 'gitcommit', 'qf', 'help', 'fugitive']
let g:better_whitespace_guicolor='#6F6565'
let g:show_spaces_that_precede_tabs=1
nnoremap <leader>et :StripWhitespace<CR>
vnoremap <leader>eT :StripWhitespace<CR>
nnoremap ]t :NextTrailingWhitespace<CR>
nnoremap [t :PrevTrailingWhitespace<CR>

" Apply editorconfig coding styles as nvim options
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
augroup my_editorconfig_ignore
	autocmd!
	au FileType gitcommit let b:EditorConfig_disable = 1
augroup END

" Align text based on regex
nnoremap <leader>ea :Tabularize /
vnoremap <leader>ea :Tabularize /
vnoremap <leader>/ :Tabularize /\/\/<CR>

" }}} Editing "

" {{{ Movement "

" Jump to word
nnoremap s <cmd>HopWord<CR>
vnoremap s <cmd>HopWord<CR>
nnoremap <C-s> <cmd>HopLine<CR>
vnoremap <C-s> <cmd>HopLine<CR>
lua require'hop'.setup()
augroup my_hop_mappings
	autocmd!
	autocmd FileType Outline nnoremap <buffer> s <cmd>HopLine<CR>
augroup END

" Jump to line number
lua require('numb').setup()

" Open file at last editing position
let g:lastplace_ignore = 'gitcommit,gitrebase,hgcommit,svn,xxd'
let g:lastplace_ignore_buftype = 'help,nofile,quickfix'
let g:lastplace_open_folds = 1

" }}} Movement "

" {{{ Search "

" grep/rg wrappers
runtime plugin/grepper.vim
let g:grepper.prompt_quote = 2
" <Tab> to switch between tools
let g:grepper.tools = ['rg_hidden', 'rg', 'grep']
let g:grepper.rg_hidden = {
\   'grepprg': 'rg -H --no-heading --vimgrep --hidden --no-ignore',
\   'grepformat': '%f:%l:%c:%m,%f',
\   'escape': '\^$.*+?()[]{}|',
\ }
nnoremap <leader>r :Grepper<CR>
nnoremap <leader>R :Grepper -stop<CR>
vmap <leader>r <plug>(GrepperOperator)

" Find definitions/references/usages without LSP
let g:any_jump_disable_default_keybindings = 1
nnoremap gs :AnyJump<CR>

" Show search matches count as virtual text
lua <<EOF
	require('hlslens').setup({
	nearest_only = true,
	nearest_float_when = 'never'
})
EOF

" }}} Search "

" {{{ Info "

" Show available mappings
lua << EOF
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil
require("which-key").setup{}
EOF
" Time to wait mapped sequence to complete (affect 'Show available mappings' plugin)
set timeoutlen=300

" Highlight todo comments
nnoremap <leader>qt <cmd>TodoQuickFix<cr>
lua require("todo-comments").setup()

" Highlight word under cursor
nnoremap <silent> <c-j> <cmd>lua require('illuminate').goto_next_reference()<CR>
nnoremap <silent> <c-k> <cmd>lua require('illuminate').goto_prev_reference()<CR>

" Show indentation
lua << EOF
require("ibl").setup {
	indent = { char = "▏" },
	exclude = {
		filetypes = {
			"markdown",
		},
	},
}
EOF
let s:my_width_of_tab = &tabstop
let s:my_expand_tab = &expandtab
let s:my_shift_width = &shiftwidth
function! s:toggleList()
	IBLToggle
	set list!
	if (&list == 1)
		let s:my_width_of_tab = &tabstop
		let s:my_shift_width = &shiftwidth
		let s:my_expand_tab = &expandtab
		set tabstop=8
		set shiftwidth=8
		set noexpandtab
	else
		let &tabstop = s:my_width_of_tab
		let &shiftwidth = s:my_shift_width
		let &expandtab = s:my_expand_tab
	endif
endfunction
nnoremap <silent> .t :call <SID>toggleList()<CR>

" Show colors of colorcodes
lua << EOF
if jit ~= nil then
	require 'colorizer'.setup{}
end
EOF
nnoremap .o :ColorizerAttachToBuffer<CR>

" Undo visualizer
nnoremap .u :MundoToggle<CR>

" Notification manager
lua <<EOF
-- Notification manager custom_instance (used in mappings)
function MyNotificationMin(str)
	local custom_opts = {
		render = "minimal",
		stages = "static",
		timeout = 1500,
	}
	local custom_instance = vim.notify.instance(custom_opts, false)
	custom_instance(str, 2, custom_opts)
end
require("notify").setup({
	timeout = 3000,
	background_colour = "#000000",
})
vim.notify = require("notify")
EOF
nnoremap <leader>n <cmd>lua require("notify").dismiss({pending=true, silent=true})<CR>

" }}} Info "

" {{{ Gui-nvim "

if exists('g:neovide')
	map <m-g> <nop>
	noremap <C-C> "+y
	noremap <C-V> "+p
	cnoremap <C-V> <C-r>+
	imap <C-V> <C-r>+
	" Gui window title
	set title titlestring=%<%F
	set guifont=JetBrainsMonoNL\ NF:h16.5:#e-subpixelantialias:#h-slight
	" let g:neovide_refresh_rate=144
endif

" }}} Gui-nvim "

scriptencoding utf-8

" {{{ Plugins initialization "

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute 'source ' . data_dir . '/autoload/plug.vim'
endif

call plug#begin()

" {{{ colorschemes "

" Plug 'EdenEast/nightfox.nvim',
Plug 'projekt0n/github-nvim-theme',

" }}} colorschemes "

" {{{ LSP/treesitter "

" Configs for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Language Servers package manager
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim',
" linters & formatters configuration plugin for efm LSP
Plug 'creativenull/efmls-configs-nvim'
" validate some popular JSON document types
Plug 'b0o/schemastore.nvim'
" Clangd's off-spec features
Plug 'p00f/clangd_extensions.nvim'
" preview of diagnostics
Plug 'folke/trouble.nvim'
" preview of an LSP symbol
Plug 'rmagatti/goto-preview',
" show function signature during editing
Plug 'ray-x/lsp_signature.nvim'
" show lightbulb when there is a code action available under cursor
Plug 'kosayoda/nvim-lightbulb'
" rename LSP symbol
Plug 'filipdutescu/renamer.nvim'
" class/symbols tree like viewer
Plug 'simrat39/symbols-outline.nvim'
" change cwd to lsp's root dir or pattern
Plug 'ahmedkhalf/project.nvim'
" LSP progress
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdateSync'}
" highlight parentheses with different colors
Plug 'hiphish/rainbow-delimiters.nvim'
" semantic nested commenting
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" motions for LSP symbols
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" show current function/condition/etc under cursor
Plug 'romgrk/nvim-treesitter-context'
" insert code annotation
Plug 'danymat/neogen'
" better integration for %
Plug 'andymass/vim-matchup'
" better folds
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

" }}} LSP/treesitter "

" {{{ Completion "

" completion engine
Plug 'hrsh7th/nvim-cmp'
" source for neovim's built-in language server client
Plug 'hrsh7th/cmp-nvim-lsp'
" source for words in buffer
Plug 'hrsh7th/cmp-buffer'
" source for filesystem paths
Plug 'hrsh7th/cmp-path'
" source for vim's cmdline
Plug 'hrsh7th/cmp-cmdline'
" source for vim-vsnip
Plug 'hrsh7th/cmp-vsnip',
" source for dictionary words
Plug 'uga-rosa/cmp-dictionary'
" source for git commit messages
Plug 'petertriho/cmp-git'
" support for LSP/VSCode's snippet format (snippets engine)
Plug 'hrsh7th/vim-vsnip'
" snippets collection
Plug 'rafamadriz/friendly-snippets'
" vscode-like icons for completion menu items
Plug 'onsails/lspkind-nvim'

" }}} Completion "

" {{{ Git "

Plug 'tpope/vim-fugitive'
" show git commit messages history under the cursor
Plug 'rhysd/git-messenger.vim'
" show git log
Plug 'junegunn/gv.vim'
" git hunks
Plug 'lewis6991/gitsigns.nvim'
" tabpage for diffs preview
Plug 'sindrets/diffview.nvim'

" }}} Git "

" {{{ Finder/Telescope "

Plug 'nvim-telescope/telescope.nvim'
" dependency for some plugins + telescope
Plug 'nvim-lua/plenary.nvim'
" compiled telescope sorter
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" jump to search entry
Plug 'nvim-telescope/telescope-hop.nvim'
" search nvim tabs
Plug 'LukasPietzschmann/telescope-tabs'

" }}} Finder/Telescope "

" {{{ Status line "

Plug 'nvim-lualine/lualine.nvim'
" icons in statusline
Plug 'kyazdani42/nvim-web-devicons'

" }}} Status line "

" {{{ Tabs & Windows & Buffers "

" buffer line
Plug 'akinsho/bufferline.nvim'
" delete buffers based on conditions
Plug 'kazhala/close-buffers.nvim'
" quickfix window helpers
Plug 'romainl/vim-qf'
" better quickfix window
Plug 'kevinhwang91/nvim-bqf'
" full screen mode
Plug 'folke/zen-mode.nvim'
" rearrange windows
Plug 'sindrets/winshift.nvim'

" }}} Tabs & Windows & Buffers "

" {{{ File explorer "

Plug 'kyazdani42/nvim-tree.lua'
Plug 'mcchrish/nnn.vim'

" }}} File explorer "

" {{{ Terminal "

Plug 'kassio/neoterm'

" }}} Terminal "

" {{{ Debugging "

" DAP client
Plug 'mfussenegger/nvim-dap'
" adapter for Neovim lua
Plug 'jbyuki/one-small-step-for-vimkind'
" variable values as virtual text
Plug 'theHamsta/nvim-dap-virtual-text'

" vim plugins debugging
Plug 'tpope/vim-scriptease'
" c/c++, bash debugger
Plug 'sakhnik/nvim-gdb',

" }}} Debugging "

" {{{ Sessions "

" continuously update ./Session.vim
Plug 'tpope/vim-obsession'
" open file at last editing position
Plug 'ethanholz/nvim-lastplace'

" }}} Sessions "

" {{{ Auto save "

Plug 'Pocco81/auto-save.nvim'

" }}} Auto save "

" {{{ Editing "

" surround with parentheses/quotes
Plug 'tpope/vim-surround'
" comment on 'gc'
Plug 'tpope/vim-commentary'
" switch between single-line/multiline code block
Plug 'AndrewRadev/splitjoin.vim'
" move visual selection up/down
Plug 'matze/vim-move'
" automatically close parentheses
Plug 'windwp/nvim-autopairs'
" increment/decrement characters
Plug 'monaqa/dial.nvim'
" draw diagrams
Plug 'jbyuki/venn.nvim'
" strip trailing whitespaces
Plug 'ntpeters/vim-better-whitespace'
" apply editorconfig coding styles as nvim options
Plug 'editorconfig/editorconfig-vim'
" align text based on regex
Plug 'godlygeek/tabular'

" }}} Editing "

" {{{ Movement "

" jump to word
Plug 'phaazon/hop.nvim'
" highlight unique characters on f/t
Plug 'unblevable/quick-scope'
" jump to line number
Plug 'nacro90/numb.nvim'

" }}} Movement "

" {{{ Search "

" grep/rg wrappers
Plug 'mhinz/vim-grepper'
" find definitions/references/usages without LSP
Plug 'pechorin/any-jump.vim'
" browser search engine (dependency of Plug 'previm/previm')
Plug 'tyru/open-browser.vim'
" show search matches count as virtual text
Plug 'kevinhwang91/nvim-hlslens'

" }}} Search "

" {{{ Info "

" show available mappings
Plug 'folke/which-key.nvim'
" highlight todo comments
Plug 'folke/todo-comments.nvim'
" highlight word under cursor
Plug 'RRethy/vim-illuminate'
" show indentation
Plug 'lukas-reineke/indent-blankline.nvim'
" show colors of colorcodes
Plug 'norcalli/nvim-colorizer.lua'
" undo visualizer
Plug 'simnalamburt/vim-mundo'
" notification manager
Plug 'rcarriga/nvim-notify'

" }}} Info "

" {{{ filetype specific "

Plug 'tmux-plugins/vim-tmux'
Plug 'pearofducks/ansible-vim'
"" Markdown
Plug 'dhruvasagar/vim-table-mode'
" previewer in browser
Plug 'iamcco/markdown-preview.nvim'
"" Markdown/reStructuredText/textile/AsciiDoc previewer in browser
Plug 'previm/previm'

" }}} filetype specific "

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	lua vim.notify("Some modules are missing, running :PlugInstall", "INFO")
	PlugInstall --sync
endif

" }}} Plugins initialization "

" {{{ Options "

" disable mouse
set mouse=
" do not add <EOL> at the end of file if it does not exist
set nofixeol
" 24-bit RGB color in terminal
set termguicolors
" highlight current line 'CursorLine'
set cursorline
" display signs in the 'number' column
set signcolumn=number
" CTRL-D move cursor to the first character on the line
set startofline
" time to wait mapped sequence to complete (affect 'show available mappings' plugin)
set timeoutlen=300
" how to display whitespace characters in 'list' mode
set listchars+=trail:,eol:,space:,tab:├─┤
" undo persistent history
set undofile
let &undodir = stdpath('data') . '/undohistory'
" show line numbers
set number
" show relative line numbers in focused window only
augroup my_numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set relativenumber   | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set norelativenumber | endif
augroup END
" if rg is installed use it for the ':grep' command
if executable('rg')
	set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" treat tab as 4 spaces by default
set tabstop=4
set shiftwidth=4
" do not wrap lines by default
set nowrap
" set filetype to text if not detected
augroup my_default_ft
	autocmd!
	autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif
augroup END

" }}} Options "

" {{{ Mappings "

let mapleader = "\<Space>"

" select (completion) mode
smap c <BS>
smap kj <esc>

" operators (c, d, y, etc...)
onoremap H 0
onoremap L $
onoremap w iw
onoremap q i"
onoremap Q i'
onoremap b i(
onoremap B i[

" visual mode
vmap m '
vnoremap M m
vnoremap H 0
vnoremap L $
vnoremap q i"
vnoremap Q i'
vnoremap j gj
vnoremap k gk
vnoremap > >gv
vnoremap < <gv
vnoremap <leader>sn "hy/<c-r>h<CR>
vnoremap <leader>sN "hy?<c-r>h<CR>
" search within visual selection
vnoremap <leader>sv <Esc>/\%V
vnoremap <leader>y "+y
vnoremap <leader>d "_d
vnoremap <expr> <leader>p (col('.') == col('$')-1) ? '"_dp' : '"_dP'
" substitute word in visual selection only
vnoremap <leader>eS :s/\%V//g<left><left><left>
" substitute selection in a file
vnoremap <leader>S "zy:%s/<c-r>z//gc<left><left><left>
" sort by line length
vnoremap <silent> <leader>es :! awk '{ print length(), $0 <Bar> "sort -n <Bar> cut -d\\  -f2-" }'<CR>

" insert mode
inoremap kj <esc>
inoremap <C-p> <C-r>"
inoremap <C-e> <C-o>$
inoremap <C-l> <Right>
inoremap <C-h> <Left>
inoremap <C-v> <c-r>+

" command line mode
cnoremap <C-v> <c-r>+

" normal mode
nmap m '
nnoremap M m
nnoremap H 0
nnoremap L $
nnoremap j gj
nnoremap k gk
nnoremap ` @q
nnoremap ~ @w
nnoremap \w :set wrap!<CR>
nnoremap \l :set rnu!<CR>:set number!<CR>
nnoremap \W :set colorcolumn=80
nnoremap . <nop>
nnoremap * <nop>
nnoremap # <nop>
nnoremap <c-w>c <nop>
nnoremap <c-a> <nop>
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
nnoremap <silent> <leader>cn :let @+ = expand("%:t")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cp :let @+ = expand("%:p")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
" relative to pwd
nnoremap <silent> <leader>cr :let @+ = expand("%")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cd :let @+ = expand("%:p:h")<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> <leader>cg :let @+ = @%.":".line('.')<CR>:lua MyNotificationMin(vim.fn.getreg('+') .. " copied to clipboard")<CR>
nnoremap <silent> [<leader> :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap <silent> ]<leader> :<c-u>put =repeat(nr2char(10), v:count1)<cr>
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>
nnoremap <silent> <leader>vr :source $MYVIMRC <Bar> PlugClean <Bar> PlugInstall<CR>
nnoremap <silent> <leader>vu :PlugUpdate --sync

" }}} Mappings "

" {{{ Functions "

lua require('MyConfigs/functions')

" change indentation to spaces
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
" change indentation to tabs
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

" }}} Functions "

" {{{ colorschemes "

" projekt0n/github-nvim-theme
:so $HOME/.config/nvim/themes/github_dark_high_contrast.vim

" EdenEast/nightfox.nvim
" :so $HOME/.config/nvim/themes/nightfox_blue.vim

" }}} colorschemes "

" {{{ LSP/treesitter "

lua require('MyConfigs/LSP_treesitter')

" LSP info
nnoremap <leader>il <cmd>LspInfo<CR>
nnoremap <leader>iL <cmd>Mason<CR>

" preview of diagnostics
lua << EOF
	require('trouble').setup {
		mode = "document_diagnostics",
		action_keys = {
			open_split = {"<c-s>"},
			open_vsplit = {"<c-v>"},
			close_folds = {"zc"},
			open_folds = {"zo"},
		},
	}
EOF
nnoremap \e <cmd>TroubleToggle<cr>

" preview of an LSP symbol
lua << EOF
	require('goto-preview').setup {
		width = 100,
		height = 20,
		bufhidden = "hide",
	}
EOF
nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>

" show function signature during editing
lua << EOF
	require('lsp_signature').setup({
		hint_enable = false,
	})
EOF

" show lightbulb when there is a code action available under cursor
lua << EOF
require('nvim-lightbulb').setup({
	sign = {
		enabled = false,
	},
	virtual_text = {
		enabled = true,
		text = "💡",
		hl_mode = "combine",
	},
	autocmd = {
		enabled = true,
		pattern = {"*"},
		updatetime = -1,
		events = {"CursorHold", "CursorHoldI"}
	},
	ignore = {
		-- LSP client names to ignore.
		clients = {"marksman","jsonls"},
	},
})
EOF

" rename LSP symbol
lua << EOF
require('renamer').setup {
	show_refs = true,
	with_qf_list = true,
	with_popup = false,
	handler = function(param)
		vim.cmd('execute "normal \\<Plug>(qf_qf_toggle_stay)"')
	end,
}
EOF
nnoremap glr <cmd>lua require("renamer").rename()<CR>

" class/symbols tree like viewer
lua << EOF
require("symbols-outline").setup({
	auto_close = false,
	width = 30,
	keymaps = {
		close = {"<Esc>"},
		focus_location = "p",
		fold = "zc",
		unfold = "zo",
		fold_all = "zM",
		unfold_all = "zR",
	},
})
EOF
" NOTE: do not map to <Tab> since <Tab> and <C-i> are same
" in the terminal and extended key <C-i> do not work in tmux
nnoremap \c :SymbolsOutline<CR>

" change cwd to lsp's root dir or pattern
lua << EOF
require("project_nvim").setup({
	detection_methods = {  "pattern", "lsp" },
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", ".root", ".marksman.toml" },
	telescope_default_action= "cd"
})
EOF

" LSP progress
lua << EOF
require("fidget").setup({
	sources = {
		["ansiblels"] = {
			ignore = true,
		},
	},
})
EOF

" treesitter
set foldlevel=99
set foldlevelstart=99
" use treesitter's = operator on whole buffer
nnoremap <silent> <expr> <leader>ei 'ggvG='.( line(".") == 1 ? '' : '<C-o>')

" highlight parentheses with different colors
lua << EOF
vim.g.rainbow_delimiters = {
	blacklist = {'markdown'},
}
EOF

" show current function/condition/etc under cursor
nnoremap \C :TSContextToggle<CR>

" insert code annotation
lua << EOF
require('neogen').setup {
	enabled = true,
}
EOF
nnoremap <leader>eA :Neogen<CR>

" better integration for %
nmap gh [%
let g:matchup_matchparen_offscreen = {}

" better folds
lua <<EOF
 --  line numbers in fold
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

" }}} LSP/treesitter "

" {{{ Completion "

set updatetime=100
set completeopt=menu,menuone,noselect
set shortmess+=c
" sync tabstop placeholder (multiple places snippets)
let g:vsnip_sync_delay = 0
let g:vsnip_choice_delay = 200
lua require('MyConfigs/nvim-cmp')

" }}} Completion "

" {{{ Git "

nnoremap <leader>gb <cmd>Telescope git_branches<cr>
nnoremap <leader>gfc <cmd>Telescope git_commits<cr>
nnoremap <leader>gfb <cmd>Telescope git_bcommits<cr>

" tpope/vim-fugitive
nnoremap <leader>gs :Git<cr><C-w>T
nnoremap <leader>gA :Gwrite<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>qd :Git difftool<cr>
nnoremap <leader>gd :tab Git diff<cr>
nnoremap <leader>gh :tab Git diff HEAD~1 HEAD<cr>
" show git objects in '+'(clipboard) register
nnoremap <leader>go :tab Git show <c-r>+<cr>
augroup my_fugitive_new_maps
	autocmd!
	autocmd FileType fugitive call <SID>SetFugitiveMaps()
	function s:SetFugitiveMaps()
		nmap <buffer> dt dp<C-w>T
		nmap <buffer> dd dp
	endfunction
augroup END

" show git commit messages history under the cursor
" o = older. Back to older commit at the line
let g:git_messenger_no_default_mappings = v:true
nnoremap <leader>gB :GitMessenger<cr>

" show git log
nnoremap <leader>gl :GV --max-count=1000<cr>

" git hunks
lua << EOF
require('gitsigns').setup {
	-- keybindings
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end
		-- Navigation
		map('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
		map('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
		-- Actions
		map('n', '<leader>ga', '<cmd>Gitsigns stage_hunk<CR>')
		map('v', '<leader>g', '<cmd>Gitsigns stage_hunk<CR>')
		map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
		map('v', '<leader>G', '<cmd>Gitsigns reset_hunk<CR>')
		map('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
		map('n', '<leader>gU', '<cmd>Gitsigns reset_buffer_index<CR>')
		map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
		map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
		-- Text object
		map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end
}
EOF

" tabpage for diffs preview
lua << EOF
local cb = require'diffview.config'.diffview_callback
require('diffview').setup ({
	keymaps = {
		view = {
			["<C-t>"] = cb("goto_file_tab"),
			["\\n"]   = cb("toggle_files"),
		},
		file_panel = {
			["s"]       = "<cmd>HopLine<CR>",
			["a"]       = cb("toggle_stage_entry"),
			["q"]       = "<cmd>HopLine<CR>",
			["<C-t>"]   = cb("goto_file_tab"),
			["\\n"]     = cb("toggle_files"),
		},
	},
})
EOF
nnoremap <leader>gD :DiffviewOpen<cr>

" " }}} Git "

" {{{ Finder/Telescope "

" builtin
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--glob=!.git,--hidden,--files<cr>
nnoremap <leader>fF <cmd>Telescope find_files find_command=rg,--no-ignore,--glob=!.git,--hidden,--files<cr>
nnoremap <leader>fr <cmd>Telescope live_grep<cr>
nnoremap <leader>fa <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>
nnoremap <leader>fM <cmd>Telescope marks<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>
nnoremap <leader>fj <cmd>Telescope jumplist<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <leader>fN <cmd>Telescope notify<cr>
nnoremap <leader>fl <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>fn <cmd>lua require('telescope.builtin').find_files({
			\ cwd = "~/.notes",
			\ find_command = { "find", "-name", "*.md" },
			\ })<cr>
" plugins
nnoremap <leader>fp <cmd>Telescope projects<cr>
nnoremap <leader>ft <cmd>Telescope telescope-tabs list_tabs<cr>
lua require('MyConfigs/telescope')

" }}} Finder/Telescope "

" {{{ Statusline "

lua require('MyConfigs/statusline')

" }}} Statusline "

" {{{ Tabs & Windows & Buffers "

" builtin
nnoremap <silent><leader>1 1gt
nnoremap <silent><leader>2 2gt
nnoremap <silent><leader>3 3gt
nnoremap <silent><leader>4 4gt
nnoremap <silent><leader>5 5gt
nnoremap <silent><leader>6 6gt
nnoremap <silent><leader>7 7gt
nnoremap <silent><leader>8 8gt
nnoremap <silent><leader>9 9gt
nnoremap <leader>Tl :<C-U>exec "tabm +" . (v:count1)<CR>
nnoremap <leader>Th :<C-U>exec "tabm -" . (v:count1)<CR>
augroup my_last_tab
	au!
	au TabLeave * let g:lasttab = tabpagenr()
augroup END
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
nnoremap <leader>t :tab sp<cr>
nnoremap <leader>D :tabclose<cr>
nnoremap <silent> <c-h> :e #<CR>

" buffer line
lua << EOF
require("bufferline").setup {
	options = {
		-- tab close icon
		close_icon = '',
		show_buffer_close_icons = false,
		indicator = {
			icon = '󰁚',
			style = 'icon',
		},
		color_icons = false,
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
nnoremap <silent> <leader>bse :BufferLineSortByExtension<CR>
nnoremap <silent> <leader>bsd :BufferLineSortByDirectory<CR>
nnoremap <silent> <leader>bst :BufferLineSortByTabs<CR>
nnoremap <silent> <leader>bp :BufferLineTogglePin<CR>

" delete buffers based on conditions
nnoremap <silent> <leader>d :BWipeout! this<CR>
nnoremap <silent> <leader>bo :BWipeout other<CR>
nnoremap <silent> <leader>bh :BWipeout hidden<CR>
nnoremap <silent> <leader>bn :BWipeout nameless<CR>

" quickfix window helpers
nmap [q <Plug>(qf_qf_previous)
nmap ]q  <Plug>(qf_qf_next)
nmap \q <Plug>(qf_qf_toggle)
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0

" better quickfix window
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
		ptogglemode = '\\f',
		stoggledown = '<C-space>',
		filter = '<C-q>'
	},
})
EOF

" full screen mode
nnoremap \f :ZenMode<CR>
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

" rearrange windows
nnoremap <C-W>m <Cmd>WinShift<CR>
nnoremap <C-W>M <Cmd>WinShift swap<CR>

" }}} Tabs & Windows & Buffers "

" {{{ File explorer "

nnoremap \n :NvimTreeFindFileToggle<CR>
lua require('MyConfigs/nvim-tree')

nnoremap <silent> \N :NnnPicker<CR>
let g:nnn#set_default_mappings = 0
let g:nnn#command = 'NNN_TMPFILE= nnn -o -Q -H -A'
let g:nnn#layout = 'vnew'
let g:nnn#action = {
		\ '<c-t>': 'tab split',
		\ '<c-x>': 'split',
		\ '<c-s>': 'vsplit' }

" }}} File explorer "

" {{{ Terminal "

let g:neoterm_default_mod = 'botright'
let g:neoterm_autojump = 1
let g:neoterm_autoinsert = 1
" execute command mapped on <leader>zm
let g:neoterm_automap_keys = '<Space>zz'
nnoremap \z :<c-u>exec v:count.'Ttoggle'<cr>
" exit from vim terminal input prompt
tnoremap <silent> <c-\> <c-\><c-n>
nnoremap <leader>zm :Tmap clear;
nnoremap <leader>zx :<c-u>exec v:count.'Tclose!'<cr>

" }}} Terminal "

" {{{ Debugging "

" neovim-lua debugger
lua require('MyConfigs/debug')
nnoremap <silent> <leader>Uc <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <leader>Us <Cmd>lua require'osv'.launch({port = 8086})<CR>
nnoremap <silent> <leader>Ux <Cmd>lua require'dap'.disconnect()<CR>

" c/c++ debugger
function! NvimGdbNoTKeymaps()
	tnoremap <silent> <buffer> kj <c-\><c-n>
endfunction
let g:nvimgdb_config_override = {
	\ 'key_breakpoint': 'r',
	\ 'key_next': 'n',
	\ 'key_step': 'i',
	\ 'key_finish': 'f',
	\ 'key_continue': 'c',
	\ 'key_until': 'u',
	\ 'key_eval': 'p',
	\ 'set_tkeymaps': 'NvimGdbNoTKeymaps',
	\ }
let g:nvimgdb_disable_start_keymaps = v:true
function s:rungdb()
	let db = input('GDB: Binary to debug path: ')
	let arg = input('GDB: '.db.' arguments: ')
	execute('GdbStart gdb -q --eval-command=start --args '.db.' '.arg)
endfunction
nnoremap <leader>ug :call <SID>rungdb()<CR>
nnoremap <leader>ux :GdbDebugStop<CR>

" }}} Debugging "

" {{{ Sessions "

set sessionoptions+=winpos,terminal

" continuously update ./Session.vim
nnoremap <leader>ss <cmd>Obsession .<cr>
function! s:update_session() range
	if &ft =~ 'gitcommit\|gitrebase\|svn\|hgcommit\|qf\|help'
		return
	endif
	if filereadable('./Session.vim')
		source ./Session.vim
		Obsession ./Session.vim
		lua vim.notify("Restored and tracking session in Session.vim", "INFO", { title = "Vim session", timeout = 100})
	endif
endfunction
augroup my_update_session
	autocmd!
	autocmd VimEnter * nested call <SID>update_session()
augroup END

" open file at last editing position
lua require'nvim-lastplace'.setup{}
let g:lastplace_ignore_buftype = 'quickfix,nofile,help,nofile'
let g:lastplace_ignore_filetype = 'gitcommit,gitrebase,svn,hgcommit'
let g:lastplace_open_folds = 1

" }}} Sessions "

" {{{ Auto save "

lua <<EOF
require("auto-save").setup({
	execution_message = {
		message = "",
	}
})
EOF

" }}} Auto save "

" {{{ Editing "

" switch between single-line/multiline code block
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap <leader>es :SplitjoinSplit<CR>
nnoremap <leader>ej :SplitjoinJoin<CR>

" move visual selection up/down
let g:move_map_keys = 0
vmap K <Plug>MoveBlockUp
vmap J <Plug>MoveBlockDown

" automatically close parentheses
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

" increment/decrement characters
nmap + <Plug>(dial-increment)
nmap - <Plug>(dial-decrement)
vmap <leader>ei <Plug>(dial-increment)
vmap <leader>ed <Plug>(dial-decrement)
vmap <leader>eI g<Plug>(dial-increment)
vmap <leader>eD g<Plug>(dial-decrement)

" draw diagrams
nnoremap <silent> \v :lua Toggle_venn()<CR>
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

" strip trailing whitespaces
let g:better_whitespace_enabled=1
let g:better_whitespace_filetypes_blacklist=['diff', 'git', 'gitcommit', 'qf', 'help', 'fugitive']
let g:better_whitespace_guicolor='#6F6565'
let g:show_spaces_that_precede_tabs=1
nnoremap <leader>et :StripWhitespace<CR>
vnoremap <leader>eT :StripWhitespace<CR>
nnoremap ]t :NextTrailingWhitespace<CR>
nnoremap [t :PrevTrailingWhitespace<CR>

" apply editorconfig coding styles as nvim options
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
augroup my_editorconfig_ignore
	autocmd!
	au FileType gitcommit let b:EditorConfig_disable = 1
augroup END

" align text based on regex
nnoremap <leader>ea :Tabularize /
vnoremap <leader>ea :Tabularize /

" }}} Editing "

" {{{ Movement "

" jump to word
nnoremap s <cmd>HopWord<CR>
vnoremap s <cmd>HopWord<CR>
nnoremap <C-s> <cmd>HopLine<CR>
vnoremap <C-s> <cmd>HopLine<CR>
lua require'hop'.setup()
augroup my_hop_mappings
	autocmd!
	autocmd FileType Outline nnoremap <buffer> s <cmd>HopLine<CR>
augroup END

" highlight unique characters on f/t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" jump to line number
lua require('numb').setup()

" }}} Movement "

" {{{ Search "

" grep/rg wrappers
runtime plugin/grepper.vim
let g:grepper.prompt_quote = 2
let g:grepper.tools = ['rg', 'rg_hidden', 'grep']
let g:grepper.rg_hidden = {
\   'grepprg': 'rg -H --no-heading --vimgrep --hidden --no-ignore',
\   'grepformat': '%f:%l:%c:%m,%f',
\   'escape': '\^$.*+?()[]{}|',
\ }
nnoremap <leader>r :Grepper<CR>
nnoremap <leader>R :Grepper -stop<CR>
vmap <leader>r <plug>(GrepperOperator)

" find definitions/references/usages without LSP
let g:any_jump_disable_default_keybindings = 1
nnoremap gs :AnyJump<CR>

" browser search engine
let g:netrw_nogx = 1 " disable netrw's gx mapping.
function s:search_github() range
	normal! gv"xy
	let context = getreg('x')
	execute 'OpenBrowserSmartSearch -github ' . context
endfunction
vmap gi <Plug>(openbrowser-smart-search)
vmap gh :<c-u>call <SID>search_github()<CR>

" show search matches count as virtual text
lua require('hlslens').setup()

" }}} Search "

" {{{ Info "

" show available mappings
lua << EOF
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil
require("which-key").setup{}
EOF

" highlight todo comments
nnoremap <leader>qt <cmd>TodoQuickFix<cr>
lua require("todo-comments").setup()

" highlight word under cursor
lua << EOF
require('illuminate').configure({
	providers = {
		'treesitter',
		'regex',
	},
	-- WARN slow down vim on large files
	-- disable 'filetypes_denylist' with loc > 'large_file_cutoff'
	large_file_cutoff = 3000,
	large_file_overrides = {
		providers = {
			'regex',
		},
		filetypes_denylist = {
			'c',
			'cpp',
		},
	},
})
EOF
nnoremap <silent> <c-j> <cmd>lua require('illuminate').goto_next_reference()<CR>
nnoremap <silent> <c-k> <cmd>lua require('illuminate').goto_prev_reference()<CR>

" show indentation
lua << EOF
require("ibl").setup {
	indent = { char = "▏" },
	exclude = {
		filetypes = {
			"markdown",
		},
	},
	scope = {
		include = {
			-- highlight all nodes (cause weird highlighting sometimes)
			-- node_type = { ["*"] = { "*" } },
			-- :InspectTree go get node_type
			node_type = {
				["*"] = {
					"argument_list",
					"arguments",
					"assignment_statement",
					"Block",
					"chunk",
					"class",
					"ContainerDecl",
					"dictionary",
					"do_block",
					"do_statement",
					"element",
					"except",
					"FnCallArguments",
					"for",
					"for_statement",
					"function",
					"function_declaration",
					"function_definition",
					"if_statement",
					"IfExpr",
					"IfStatement",
					"import",
					"InitList",
					"list_literal",
					"method",
					"object",
					"ParamDeclList",
					"repeat_statement",
					"selector",
					"SwitchExpr",
					"table",
					"table_constructor",
					"try",
					"tuple",
					"type",
					"var",
					"while",
					"while_statement",
					"with",
				},
			},
		},
	}
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
nnoremap <silent> \t :call <SID>toggleList()<CR>

" show colors of colorcodes
lua << EOF
if jit ~= nil then
	require 'colorizer'.setup{}
end
EOF
nnoremap \o :ColorizerAttachToBuffer<CR>

" undo visualizer
nnoremap \u :MundoToggle<CR>

" notification manager
lua <<EOF
require("notify").setup({
	timeout = 3000,
})
vim.notify = require("notify")
EOF
nnoremap <leader>n <cmd>lua require("notify").dismiss({pending=true, silent=true})<CR>

" }}} Info "

" {{{ filetype specific "

" Markdown previewer in browser
" workaround for https://github.com/iamcco/markdown-preview.nvim/issues/497
augroup my_markdown_preview_postinstall
	autocmd!
	autocmd BufEnter *.md call <SID>post_install_markdown_preview()
	function s:post_install_markdown_preview()
		if exists(':MarkdownPreviewToggle')
			call mkdp#util#install()
		endif
	endfunction
augroup END

" }}} filetype specific "

" {{{ Gui-nvim "

if exists('g:neovide')
	map <m-g> <nop>
	noremap <C-C> "+y
	noremap <C-V> "+p
	cnoremap <C-V> <C-r>+
	imap <C-V> <C-r>+
	" gui window title
	set title titlestring=%<%F
	set guifont=JetBrainsMonoNL\ NF:h16.5:#e-subpixelantialias:#h-slight
	" let g:neovide_refresh_rate=144
endif

" }}} Gui-nvim "

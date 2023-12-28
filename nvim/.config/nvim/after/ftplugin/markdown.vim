nnoremap <buffer> K <nop>
setlocal conceallevel=2
" decrease/increase headers in visual selection
xnoremap <buffer> - :s/^#//g<CR>gv
xnoremap <buffer> + :s/^\(.*#\)/\1#/g<CR>gv

" tpope/vim-surround
" echo char2nr(" ")
" Sb: bold
let b:surround_98 = "**\r**"
" Si: italics
let b:surround_105 = "*\r*"
" Sl: link
let b:surround_108 = "[[\r]]"
" Sh: header
let b:surround_104 = "## \r #"

" iamcco/markdown-preview.nvim
nnoremap <buffer> \p :MarkdownPreviewToggle<CR>

" dhruvasagar/vim-table-mode
nnoremap <buffer> <silent> <leader>Fa :TableModeRealign<CR>
nnoremap <buffer> <silent> <leader>Ft :TableModeToggle<CR>

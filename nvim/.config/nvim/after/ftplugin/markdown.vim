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
let g:mkdp_auto_close = 0

" dhruvasagar/vim-table-mode
" enter '|' to create new row/align existing table
nnoremap <buffer> <silent> <leader>Fa :TableModeRealign<CR>
nnoremap <buffer> <silent> <leader>Ft :TableModeToggle<CR>

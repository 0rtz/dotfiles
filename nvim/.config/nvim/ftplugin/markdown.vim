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

" 'preservim/vim-markdown'
let g:vim_markdown_follow_anchor = 1
" convert "(#anchor-name)" to search string "anchor name"
let g:vim_markdown_anchorexpr = "substitute(v:anchor, '-', ' ', 'g')"
" case insensitive search for anchors
setlocal ignorecase
let g:vim_markdown_folding_disabled = 1
setlocal conceallevel=2
xnoremap <buffer> - :HeaderDecrease<CR>gv
xnoremap <buffer> + :HeaderIncrease<CR>gv
nnoremap <buffer> <leader>Fc :InsertToc<CR>
nmap <buffer> gl ge
" https://github.com/preservim/vim-markdown/issues/138
augroup LessInMarkdown
	autocmd! * <buffer>
	autocmd Syntax <buffer>
		\ syn clear htmlTag |
		\ syn region htmlTag start=+<[^/]+ end=+>+ fold oneline contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster
augroup END

" 'godlygeek/tabular'
function s:toggleTableFormatAutoGroup()
    if !exists('#TabularInMarkdown#CursorMovedI')
		augroup TabularInMarkdown
			autocmd! * <buffer>
			" TableFormat = dependency of 'preservim/vim-markdown'
			autocmd CursorMovedI <buffer> TableFormat
		augroup END
		lua MyNotificationMin("table formatting enabled")
    else
        augroup TabularInMarkdown
            autocmd!
        augroup END
		lua MyNotificationMin("table formatting disabled")
    endif
endfunction
nnoremap <buffer> <silent> <leader>Ft :call <SID>toggleTableFormatAutoGroup()<CR>

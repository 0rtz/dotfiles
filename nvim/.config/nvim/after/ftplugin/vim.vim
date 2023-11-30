setlocal foldmethod=marker
setlocal foldlevel=0

function s:vimSectionFolds()
    let l:filename = expand('%')
    let l:lines = getbufline('%', 0, '$')
    let l:lines = map(l:lines, {index, value -> {"lnum": index + 1, "text": value, "filename": l:filename}})
    call filter(l:lines, {_, value -> value.text =~# '^".*{{{.*$'})
    call setqflist(l:lines)
    Telescope quickfix
endfunction

nnoremap <buffer> <leader>Ff :call <SID>vimSectionFolds()<cr>

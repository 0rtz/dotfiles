" Vim filetype plugin
" Language:	spec file
" Maintainer:	Guillaume Rousse <guillomovitch@zarb.org>
" URL:		http://www.zarb.org/~guillomovitch/linux/spec.vim
" Version:	$Id: spec.vim 181 2005-07-21 18:37:45Z guillaume $

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" Add mappings, unless user doesn't want
if !exists("no_plugin_maps") && !exists("no_spec_maps")
	if !hasmapto("<Plug>AddChangelogEntry")
		map <buffer> <leader>Fl <Plug>AddChangelogEntry
	endif
	if !hasmapto("<Plug>AddChangelogItem")
		map <buffer> <leader>FL <Plug>AddChangelogItem
	endif
	if !hasmapto("<Plug>ExpandMacro")
		map <buffer> <leader>Fm <Plug>ExpandMacro
	endif
	noremap <buffer> <unique> <script> <Plug>AddChangelogEntry :call <SID>AddChangelogEntry()<CR>
	noremap <buffer> <unique> <script> <Plug>AddChangelogItem :call <SID>AddChangelogItem()<CR>
	noremap <buffer> <unique> <script> <Plug>ExpandMacro :echo <SID>GetMacroValue(expand('<cword>'))<CR>
endif

" compilation option
setlocal makeprg=rpm\ -ba\ %
setlocal errorformat=error:\ line\ %l:\ %m

" navigation through sections
let b:match_ignorecase = 0
let b:match_words =
	\ '^Name:^%description:^%clean:^^%setup:^%build:^%install:^%files:' .
	\ '^%package:^%pre:^%post:^%changelog:^%check'

if !exists("*s:AddChangelogEntry")
	" Adds a changelog entry
	function s:AddChangelogEntry()
		" look for changelog section
		let l:line = <SID>LocateChangelogSection()
		" insert changelog header just after
		call <SID>InsertChangelogHeader(l:line)
		" insert changelog item just after
		call <SID>InsertChangelogItem(l:line + 1)
	endfunction
endif

if !exists("*s:AddChangelogItem")
	" Adds a changelog item
	function s:AddChangelogItem()
		" look for changelog section
		let l:line = <SID>LocateChangelogSection()
		" look for first header
		let l:entry = search('^\*', 'W')
		if l:entry == 0
			call <SID>InsertChangelogHeader(l:line)
			let l:entry = l:line + 1
		endif
		" look for either first or last item
		if exists("g:spec_chglog_prepend")
			let l:item = l:entry
		else
			let l:item = search('^$', 'W')
			if l:item == 0
				let l:item = line('$')
			else
				let l:item = l:item - 1
			endif
		endif
		call <SID>InsertChangelogItem(l:item)
	endfunction
endif

if !exists("*s:LocateChangelogSection")
	" Locate changelog section, creating it if needed
	function s:LocateChangelogSection()
		let l:line = search('^%changelog', 'w')
		if l:line == 0
			let l:line = line('$')
			if getline(l:line) !~ '^$'
				call append(l:line, '')
				let l:line = l:line + 1
			endif
			call append(l:line, '%changelog')
			let l:line = l:line + 1
			call cursor(l:line, 1)
		endif
		return l:line
	endfunction
endif

if !exists("*s:InsertChangelogHeader")
	" Insert a changelog header at the given line
	function s:InsertChangelogHeader(line)
		" ensure english locale
		language time C
		" read values from configuration
		let s:date = exists("g:spec_chglog_date") ? g:spec_chglog_date : "%a %b %e %X UTC %Y -"
		let s:packager =  exists("g:spec_chglog_packager") ? g:spec_chglog_packager : <SID>GetExternalMacroValue("packager")
		" compute header
		let l:header = "*"
		if strlen(s:date)
			let l:header = l:header . ' ' . strftime(s:date)
		endif
		if strlen(s:packager)
			let l:header = l:header . ' ' . s:packager
		endif
		" insert blank line if needed
		if getline(a:line + 1) !~ '^$'
			call append(a:line, "")
		endif
		" insert changelog header
		call append(a:line, l:header)
		" position cursor here
		call cursor(a:line + 1, 1)
	endfunction
endif

if !exists("*s:InsertChangelogItem")
	" Insert a changelog entry at the given line
	function s:InsertChangelogItem(line)
		" insert changelog entry
		call append(a:line, "- ")
		" position cursor here
		call cursor(a:line + 1, 1)
		" enter insert mode
		startinsert!
	endfunction
endif

if !exists("*s:GetTagValue")
	" Return value of a rpm tag
	function s:GetTagValue(tag)
		let l:pattern = '^' . a:tag . ':\s*'
		let l:line = search(l:pattern, 'w')
		if l:line != 0
			let l:string = getline(l:line)
			let l:value = substitute(l:string, l:pattern, "", "")

			" resolve macros
			while (l:value =~ '%{\?\w\{3,}}\?')
				let l:macro = matchstr(l:value, '%{\?\w\{3,}}\?\(\s\+.\+\)\?')
				if l:macro =~ '%\w\{3,}\s\+.\+'
					let l:macro_name = substitute(l:macro, '%\(\w\{3,}\s\+\)', '\1', "")
					let l:macro_value = <SID>GetExternalMacroValue(l:macro_name)
					let l:value = substitute(l:value, '%' . l:macro_name, l:macro_value, "")
				else
					let l:macro_name = substitute(l:macro, '%{\?\(\w\{3,}\)}\?', '\1', "")
					let l:macro_value = <SID>GetMacroValue(l:macro_name)
					let l:value = substitute(l:value, '%{\?' . l:macro_name . '}\?', l:macro_value, "")
				endif
			endwhile
		else
			let l:value = ''
		endif
		return l:value
	endfunction
endif

if !exists("*s:GetMacroValue")
	" Return value of a rpm macro
	function s:GetMacroValue(macro)
		let l:pattern = '^%define\s*' . a:macro . '\s*'
		let l:line = search(l:pattern, 'ws')
		if l:line != 0
			let l:string = getline(l:line)
			let l:value = substitute(l:string, l:pattern, "", "")
		else
			" try to read externaly defined values
			let l:value = <SID>GetExternalMacroValue(a:macro)
		endif
		return l:value
	endfunction
endif

if !exists("*s:GetExternalMacroValue")
	" Return value of an external rpm macro
	function s:GetExternalMacroValue(macro)
		let l:value = system("rpm --eval '%" . a:macro . "'")
		let l:value = strpart(l:value, 0, strlen(l:value) - 1)
		" return empty string for unknown macros
		if l:value == "%" . a:macro
			let l:value = "Could not read that: %".a:macro
		endif
		return l:value
	endfunction
endif

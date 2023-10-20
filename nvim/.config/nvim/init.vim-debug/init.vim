let g:my_plug_dir = $HOME . '/.tmp/init.vim-debug'
if !filereadable(g:my_plug_dir . '/autoload/plug.vim')
	silent execute '!curl -fLo '.g:my_plug_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute 'source ' . g:my_plug_dir . '/autoload/plug.vim'
end

call plug#begin(g:my_plug_dir . '/vim-plug')
" :PPmsg var
Plug 'tpope/vim-scriptease'
call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	echom 'Some modules are missing, running :PlugInstall'
	PlugInstall
endif

let mapleader = "\<Space>"

lua <<EOF

function Log(...)
	local objects = {}
		for i = 1, select('#', ...) do
			local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	local message = table.concat(objects, '\n')
	print(message)

	local log_file_path = vim.g.my_plug_dir .. '/Log.txt'
	local log_file = io.open(log_file_path, "w")
	io.output(log_file)
	io.write(message)
	io.close(log_file)

	return ...
end

EOF

nnoremap <leader>a :<cr>

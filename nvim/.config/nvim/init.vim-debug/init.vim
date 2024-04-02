let g:my_plug_dir = $HOME . '/.tmp/init.vim-debug'
if !filereadable(g:my_plug_dir . '/autoload/plug.vim')
	silent execute '!curl -fLo '.g:my_plug_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute 'source ' . g:my_plug_dir . '/autoload/plug.vim'
end

call plug#begin(g:my_plug_dir . '/vim-plug')

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	echom 'Some modules are missing, running :PlugInstall'
	PlugInstall
endif

lua <<EOF

EOF

" nnoremap <Space>a :<cr>

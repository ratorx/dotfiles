let s:dein_base=$XDG_DATA_HOME . '/dein'
let s:dein_runtime=s:dein_base . '/repos/github.com/Shougo/dein.vim'

" plugins
let s:plugins=['plugins']
call map(s:plugins, 'g:config_base . "/" . v:val . ".toml"')

" install if not present
if !isdirectory(s:dein_runtime)
	call mkdir(s:dein_runtime, 'p', '0755')
	call system('git clone https://github.com/Shougo/dein.vim ' . s:dein_runtime)
endif

augroup autoreload
	for path in s:plugins
		execute 'autocmd BufWritePost ' . path . ' call dein#recache_runtimepath()'
	endfor
augroup END

let g:dein#enable_notification=1
let g:dein#install_progress_type='title'

execute 'set runtimepath+=' . s:dein_runtime
if dein#load_state(s:dein_runtime)
	call dein#begin(s:dein_runtime, s:plugins)
	for path in s:plugins
		call dein#load_toml(path)
	endfor
	call dein#end()
	call dein#save_state()
endif

call dein#call_hook('source')
call dein#call_hook('post_source')

if dein#check_install()
	call dein#install()
endif

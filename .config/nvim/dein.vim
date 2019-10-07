let s:deinpath=$XDG_DATA_HOME.'/dein'
let s:deinruntimepath=s:deinpath.'/repos/github.com/Shougo/dein.vim'
let s:configpath=$XDG_CONFIG_HOME.'/nvim'
let s:pluginspath=s:configpath.'/plugins.toml'
let s:lsplangs=['rust', 'python', 'go']
let s:otherlangs=['sh', 'tex', 'vim']

" install if not present
if !isdirectory(s:deinruntimepath)
	call mkdir(s:deinruntimepath, 'p', '0755')
	call system('git clone https://github.com/Shougo/dein.vim '.s:deinruntimepath)
endif

augroup autoreload
	execute 'autocmd BufWritePost '.s:pluginspath.' call dein#recache_runtimepath()'
augroup END

let g:dein#enable_notification=1
let g:dein#install_progress_type='title'

execute 'set runtimepath+='.s:deinruntimepath
if dein#load_state(s:deinruntimepath)
	call dein#begin(s:deinruntimepath, s:pluginspath)
	call dein#load_toml(s:configpath . '/plugins.toml')
	call dein#end()
	call dein#save_state()
endif

call dein#call_hook('source')
call dein#call_hook('post_source')

if dein#check_install()
	call dein#install()
endif

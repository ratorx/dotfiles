let g:config_base=$XDG_CONFIG_HOME.'/nvim'

let s:config=['options', 'mappings', 'dein']
for path in s:config
	execute 'source ' . g:config_base . '/' . path . '.vim'
endfor

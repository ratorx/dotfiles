let g:config_base=$XDG_CONFIG_HOME.'/nvim'

if !exists('g:vscode')
  let s:config=['options', 'mappings', 'dein']
  for path in s:config
    execute 'source ' . g:config_base . '/' . path . '.vim'
  endfor
endif

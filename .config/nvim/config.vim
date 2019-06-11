scriptencoding utf8

" lightline
let g:lightline={}
let g:lightline.colorscheme='one'
let g:lightline.enable={'statusline': 1, 'tabline': 1}
let g:lightline.component={'lineinfo': '%2l/%2L:%2v'}
let g:lightline.component_type = {}
let g:lightline.active={'right': [['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]}
set laststatus=2

" vim-rooter
let g:rooter_patterns = ['Cargo.toml', '.project_base', '.git/', 'README.md', 'Makefile']

" signify
let g:signify_sign_show_count=0
let g:signify_sign_delete='—'
let g:signify_sign_change='~'

" dein
command DeinInstall call dein#install()
command DeinRecache call dein#recache_runtimepath()

" ale
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_error='‼'
let g:ale_sign_warning='!'
let g:ale_rust_check_all_targets=0
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=1
let g:ale_fix_on_save=1

let g:ale_linters={}
let g:ale_linters.sh=['shellcheck']
let g:ale_linters.go=[]
let g:ale_linters.python=[]
let g:ale_linters.tex=['chktex']
let g:ale_linters.rust=[]
let g:ale_linters.vim=['vint']

let g:ale_fixers={}
let g:ale_fixers.go=['goimports']
let g:ale_fixers.python=['black', 'isort']
let g:ale_fixers.rust=['rustfmt']

" vim-polyglot
let g:polyglot_disabled=['latex']

" deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#max_list=5
let g:deoplete#ignore_sources={}
let g:deoplete#ignore_sources.go=['around', 'buffer', 'dictionary', 'member']
let g:deoplete#ignore_sources.python=['around', 'buffer', 'dictionary', 'member']
let g:deoplete#ignore_sources.rust=['around', 'buffer', 'dictionary', 'member']
set completeopt-=preview

" LanguageClient-neovim
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
let g:LanguageClient_useVirtualText=0
let g:LanguageClient_serverCommands={}
let g:LanguageClient_serverCommands.go=['bingo']
let g:LanguageClient_serverCommands.python=['pyls']
let g:LanguageClient_serverCommands.rust=['rustup', 'run', 'stable', 'rls']

let g:LanguageClient_diagnosticsDisplay={}
let g:LanguageClient_diagnosticsDisplay.1={
      \  'name': 'Error',
      \  'texthl': 'ALEError',
      \  'signText': '‼',
      \  'signTexthl': 'ALEErrorSign',
      \  'virtualTexthl': 'Error',
      \ }
let g:LanguageClient_diagnosticsDisplay.2={
      \  'name': 'Warning',
      \  'texthl': 'ALEWarning',
      \  'signText': '!',
      \  'signTexthl': 'ALEWarningSign',
      \  'virtualTexthl': 'Todo',
      \ }
let g:LanguageClient_diagnosticsDisplay.3={
      \  'name': 'Information',
      \  'texthl': 'ALEInfo',
      \  'signText': '!',
      \  'signTexthl': 'ALEInfoSign',
      \  'virtualTexthl': 'Todo',
      \ }
let g:LanguageClient_diagnosticsDisplay.4={
      \  'name': 'Hint',
      \  'texthl': 'ALEInfo',
      \  'signText': '!',
      \  'signTexthl': 'ALEInfoSign',
      \  'virtualTexthl': 'Todo',
      \ }

" vimtex
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_progname='nvr'

let g:vimtex_quickfix_latexlog = {
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \ 'packages' : {
      \   'default' : 0 }
      \ }

augroup vimtex " cleanup on exit
  au!
  au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END

" Goyo.vim
function! s:goyo_enter()
  augroup relnum
    au!
  augroup END
  set noautoindent nosmartindent
endfunction

augroup goyo_custom
  au!
  au User GoyoEnter nested call <SID>goyo_enter()
augroup END

" Tagbar
let g:tagbar_left = 1
let g:rust_use_custom_ctags_defs = 1
let g:tagbar_type_rust = {
  \ 'ctagsbin' : '/usr/bin/ctags',
  \ 'ctagstype' : 'rust',
  \ 'kinds' : [
      \ 'n:modules',
      \ 's:structures:1',
      \ 'i:interfaces',
      \ 'c:implementations',
      \ 'f:functions:1',
      \ 'g:enumerations:1',
      \ 't:type aliases:1:0',
      \ 'v:constants:1:0',
      \ 'M:macros:1',
      \ 'm:fields:1:0',
      \ 'e:enum variants:1:0',
      \ 'P:methods:1',
  \ ],
  \ 'sro': '::',
  \ 'kind2scope' : {
      \ 'n': 'module',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'c': 'implementation',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'M': 'macro',
      \ 'm': 'field',
      \ 'e': 'enumerator',
      \ 'P': 'method',
  \ },
\ }
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

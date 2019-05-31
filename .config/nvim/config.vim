scriptencoding utf8
" true color support
if (has('nvim'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has('termguicolors'))
    let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
    let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'
    set termguicolors
endif

set linebreak breakindent
set scrolloff=1 sidescrolloff=5
set conceallevel=2
set backspace=2 " backspace wrapping
" relative numbering
set number relativenumber
augroup relnum
  au!
  au InsertEnter * :setlocal norelativenumber
  au InsertLeave * :setlocal relativenumber
augroup END
set hidden " open new files without saving
set showtabline=1
filetype plugin indent on
set splitbelow splitright " better splits
set cursorline
set ignorecase smartcase
set wildmode=longest:full,full
set foldmethod=indent foldlevel=99

augroup cursor_fix
  autocmd!
  autocmd VimLeave * set guicursor=a:ver25
augroup END

augroup ftdetect_prolog " prefer prolog
  autocmd!
  autocmd BufRead,BufNewFile *.pl set filetype=prolog
augroup END

" auto directory creation
augroup autodir
  autocmd!
  autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END

" undodir
if !isdirectory($HOME.'/.cache')
    call mkdir($HOME.'/.cache', '', '0755')
endif
if !isdirectory($HOME.'/.cache/nvim')
    call mkdir($HOME.'/.cache/nvim', '', '0700')
endif
set undodir=~/.cache/nvim
set undofile

set mouse=a

syntax enable 
set background=dark
color one

let g:python3_host_prog='/usr/bin/python3'

" lightline
let g:lightline={}
let g:lightline.colorscheme='one'
let g:lightline.enable={'statusline': 1, 'tabline': 1}
let g:lightline.active={'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ], ['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]}
let g:lightline.component={'lineinfo': '%2l/%2L:%2v'}
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#lsc#checking',
      \  'linter_warnings': 'lightline#lsc#warnings',
      \  'linter_errors': 'lightline#lsc#errors',
      \  'linter_ok': 'lightline#lsc#ok',
      \ }
let g:lightline.component_type = {
      \  'buffers': 'tabsel', 
      \  'linter_checking': 'left',
      \  'linter_warnings': 'warning',
      \  'linter_errors': 'error',
      \  'linter_ok': 'left',
      \ }
let g:lightline.component_type={'linter_warnings': 'warning', 'linter_errors': 'error'}
set laststatus=2

" vim-rooter
let g:rooter_patterns = ['Cargo.toml', '.project_base', '.git/']

" signify
let g:signify_sign_show_count=0
let g:signify_sign_delete='—'
let g:signify_sign_change='~'

" dein
command DeinInstall call dein#install()
command DeinRecache call dein#recache_runtimepath()

" ale
let g:ale_sign_error='‼'
let g:ale_sign_warning='!'
let g:ale_rust_check_all_targets=0
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=1
let g:ale_fix_on_save=1

let g:ale_linters={}
let g:ale_linters.sh=['shellcheck']
let g:ale_linters.bash=['shellcheck']
let g:ale_linters.c=[]
let g:ale_linters.cpp=[]
let g:ale_linters.go=['bingo']
let g:ale_linters.python=['flake8']
let g:ale_linters.java=[]
let g:ale_linters.tex=['chktex']
let g:ale_linters.rust=[]

let g:ale_fixers={}
let g:ale_fixers.c=['clang-format']
let g:ale_fixers.cpp=['clang-format']
let g:ale_fixers.go=['goimports']
let g:ale_fixers.python=['black']
let g:ale_fixers.java=[]
let g:ale_fixers.rust=['rustfmt']

" ale options
let g:ale_c_clangformat_options='-style=Google'
let g:ale_python_flake8_options='--ignore=E203,E501,W503'
let g:ale_rust_cargo_use_clippy=executable('cargo-clippy')
let g:ale_type_map={'flake8': {'ES': 'WS'}}

" vim-polyglot
let g:polyglot_disabled=['latex']

" deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#max_list=10
let g:deoplete#ignore_sources={}
let g:deoplete#ignore_sources.rust=['around', 'buffer', 'dictionary', 'member']
let g:deoplete#ignore_sources.python=['around', 'buffer', 'dictionary', 'member']
let g:deoplete#ignore_sources.go=['around', 'buffer', 'dictionary', 'member']
set completeopt-=preview

" C/C++
let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header='/usr/lib/clang'
" Go
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

" LanguageClient-neovim
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
let g:LanguageClient_useVirtualText=0
let g:LanguageClient_serverCommands={}
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
  au User GoyoLeave execute 'wq'
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

set linebreak breakindent
set scrolloff=1 sidescrolloff=5
set undolevels=10000
set conceallevel=2
set nohlsearch
set backspace=2 " backspace wrapping
set number relativenumber
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber
set hidden " open new files without saving
set showtabline=2
filetype plugin indent on
set splitbelow splitright
set cursorline
set ignorecase smartcase
set softtabstop=0 expandtab smarttab
set tabstop=4 shiftwidth=4
au FileType c* setlocal tabstop=2 shiftwidth=2
augroup ftdetect_prolog " prefer prolog
  autocmd!
  autocmd BufRead,BufNewFile *.pl set filetype=prolog
augroup END
if !has('nvim')
    set encoding=utf8
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
    set termguicolors
endif

set mouse=a
let mapleader="\<SPACE>"
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
cmap w!! w suda://%
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR>

" Hard Mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

syntax enable 
color onedark

let g:python3_host_prog='/usr/bin/python'

" lightline
let g:lightline={'colorscheme': 'onedark',
    \            'active': {'right': [[ 'linter_errors', 'linter_warnings', 'linter_ok' ], ['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]},
    \            'tabline': {'left': [['buffers']]},
    \            'component_expand': {'buffers': 'lightline#bufferline#buffers', 'linter_warnings': 'lightline#ale#warnings', 'linter_errors': 'lightline#ale#errors', 'linter_ok': 'lightline#ale#ok'},
    \            'component_type': {'buffers': 'tabsel', 'linter_warnings': 'warning', 'linter_errors': 'error'},
    \           }
let g:lightline.component={'lineinfo': '%2l/%2L:%2v'}
set laststatus=2

" dein
command PlugInstall call dein#install()
command PlugReinstall call dein#recache_runtimepath()
command PlugUpdate call dein#update()

" fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-F> :Lines<CR>

" ale
let g:ale_sign_error='‼'
let g:ale_sign_warning='!'
let g:ale_rust_check_all_targets=0
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=1
let g:ale_fix_on_save=1
let g:ale_linters={
\                    'sh': ['shellcheck'],
\                    'bash': ['shllcheck'],
\                    'c': ['clang'],
\                    'cpp': ['clang'],
\                    'go': ['gometalinter'],
\                    'python': ['flake8'],
\                    'java': [],
\                    'tex': ['chktex'],
\                    'rust': ['rls'],
\                 }
let g:ale_fixers={
\                    'c': ['clang-format'],
\                    'cpp': ['clang-format'],
\                    'go': ['goimports'],
\                    'python': ['black'],
\                    'java': [],
\                    'rust': ['rustfmt'],
\                }

" ale options
let g:ale_go_gometalinter_executable='gometalinter.v2'
let g:ale_go_gometalinter_options='--fast'
let g:ale_c_clangformat_options='-style=Google'
let g:ale_python_flake8_options='--ignore=E203,E501,W503'
let g:ale_type_map = {'flake8': {'ES': 'WS'}}

" vim-polyglot
let g:polyglot_disabled=['latex']

" deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#max_list=5
set completeopt-=preview

inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#mappings#manual_complete()

inoremap <silent><expr> <S-TAB>
\ pumvisible() ? "\<C-p>" :
\ <SID>check_back_space() ? "\<S-TAB>" :
\ deoplete#mappings#manual_complete()

function! s:check_back_space() abort "{{{
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" C/C++
let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header='/usr/lib/clang'
" Go
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" Rust
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$RUST_SRC_PATH

" neosnippet
imap <C-e> <Plug>(neosnippet_expand_or_jump)
smap <C-e> <Plug>(neosnippet_expand_or_jump)

" vimtex
" au FileType tex setlocal foldmethod=indent foldlevelstart=99
let g:vimtex_view_method='zathura'
nmap \lv :VimtexView<CR>

augroup vimtex_event_1 " cleanup on exit
  au!
  au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END

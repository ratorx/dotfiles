let g:python3_host_prog='/usr/bin/python'
set encoding=utf8
set wrap linebreak breakindent
set clipboard=unnamed " system clipboard
set scrolloff=1 sidescrolloff=5
set undolevels=10000
set conceallevel=2
set noerrorbells
set nohlsearch
set backspace=indent,eol,start " backspace wrapping
au VimLeave * set guicursor=a:ver30-iCursor
set number relativenumber
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber
syntax on 
if has('nvim') || has('termguicolors')
  set termguicolors
endif
set mouse=a
set hidden " open new files without saving
set showtabline=2
filetype plugin indent on
set splitbelow
set splitright
set cursorline
set ignorecase
set smartcase
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
au FileType c* setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
augroup ftdetect_prolog " prefer prolog
  autocmd!
  autocmd BufRead,BufNewFile *.pl set filetype=prolog
augroup END

let mapleader="\<SPACE>"
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
cmap w!! w !sudo tee > /dev/null %
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR>
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Splits
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>

color onedark
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

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
\                    'c': ['clang'],
\                    'cpp': ['clang'],
\                    'go': ['gometalinter'],
\                    'python': ['flake8'],
\                    'java': [],
\                    'tex': ['chktex']
\                 }
let g:ale_fixers={
\                    'c': ['clang-format'],
\                    'cpp': ['clang-format'],
\                    'go': ['goimports'],
\                    'python': ['yapf'],
\                    'java': [],
\                }

" ale options
let g:ale_go_gometalinter_executable='gometalinter.v2'
let g:ale_go_gometalinter_options='--fast'
let g:ale_c_clangformat_options='-style=Google'

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
augroup vimtex_event_1 " cleanup on exit
  au!
  au User VimtexEventQuit     call vimtex#compiler#clean(0)
augroup END


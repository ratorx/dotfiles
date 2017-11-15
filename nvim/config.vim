" Set standard file encoding
set encoding=utf8
" No special per file vim overide configs
set nomodeline
" Stop word wrapping
set nowrap
  " Except on Markdown
  autocmd FileType markdown setlocal wrap
" Adjust system undo levels
set undolevels=10000
" Use system clipboard
set clipboard=unnamed
" Don't let Vim hide characters
set conceallevel=1
set noerrorbells
" Use search highlighting
set hlsearch
" Space above/beside cursor from screen edges
set scrolloff=1
set sidescrolloff=5
" Mouse support
set mouse=a
" arrow key and backspace wrapping
set whichwrap+=<,>,[,]
set backspace=indent,eol,start
" cursor reset
au VimLeave * set guicursor=a:ver30-iCursor-blinkon0
" Turn of hlsearch
nnoremap <CR> :noh<CR><CR>
" Relative line numbers & hlsearch
set number relativenumber
autocmd InsertEnter * :setlocal norelativenumber nohlsearch
autocmd InsertLeave * :setlocal relativenumber hlsearch
" Turn on syntax highlighting
syntax on 
" True Colours
if has('nvim') || has('termguicolors')
  set termguicolors
endif
" Tab switching without saving
set hidden
set showtabline=2
" Automatic indentation
filetype plugin indent on
" Natural Splits
set splitbelow
set splitright
" Highlight current line
set cursorline
" Smart case
set ignorecase
set smartcase
" Better Tabs
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

au FileType c* setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

let mapleader="\<SPACE>"
" Return to last opened file
nmap <Leader><Leader> <c-^>

" Tab browsing
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR><Paste>

" Colour Scheme
color onedark
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
" Plugin settings

" lightline
" let g:lightline={'colorscheme': 'onedark'}
let g:lightline={'colorscheme': 'onedark',
    \            'active': {'right': [[ 'linter_errors', 'linter_warnings', 'linter_ok' ], ['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]},
    \            'tabline': {'left': [['buffers']]},
    \            'component_expand': {'buffers': 'lightline#bufferline#buffers', 'linter_warnings': 'lightline#ale#warnings', 'linter_errors': 'lightline#ale#errors', 'linter_ok': 'lightline#ale#ok'},
    \            'component_type': {'buffers': 'tabsel', 'linter_warnings': 'warning', 'linter_errors': 'error'},
    \           }
let g:lightline.component={'lineinfo': '%2v:%2l/%2L'}
set laststatus=2

" lightline-buffer


" fzf
nnoremap <Leader><Leader>f :Files<CR>
nnoremap <Leader><Leader>b :Lines<CR>
nnoremap <Leader><Leader>gf :GFiles<CR>
nnoremap <Leader><Leader>gs :GFiles?<CR>

" vim-easymotion
map <Leader> <Plug>(easymotion-prefix)

" ale
let g:ale_sign_error='!!'
let g:ale_sign_warning='!'
let g:ale_rust_check_all_targets=0
let g:ale_lint_on_text_changed='never'
let g:ale_fix_on_save=1
let g:ale_linters={
\                    'c': ['clangtidy'],
\                    'cpp': ['clangtidy'],
\                    'go': ['gometalinter'],
\                    'python': ['flake8'],
\                 }
let g:ale_fixers={
\                    'c': ['clang-format'],
\                    'cpp': ['clang-format'],
\                    'go': ['gofmt'],
\                    'python': ['yapf'],
\                    'rust': ['rustfmt'],
\                }

" Language specific ale options
let g:ale_cpp_clangtidy_checks=["*", "-cppcoreguidelines-pro-bounds-pointer-arithmetic", "-llvm-header-guard", "-clang-diagnostic-c++11-extensions"]
let g:ale_go_meta_linter_executable='gometalinter.v1'
let g:ale_gometalinter_options='--exclude=errcheck'

" deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#max_list=5
set completeopt-=preview
" Completion direction
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


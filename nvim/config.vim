" Set standard file encoding
set encoding=utf8
" No special per file vim overide configs
set nomodeline
" Word wrapping
set wrap linebreak breakindent
" Adjust system undo levels
set undolevels=10000
" Use system clipboard
set clipboard=unnamed
" Don't let Vim hide characters
set conceallevel=1
set noerrorbells
" Don't highlight searches
set nohlsearch
" Space above/beside cursor from screen edges
set scrolloff=1 sidescrolloff=5
" Mouse support
set mouse=a
" arrow key and backspace wrapping
set backspace=indent,eol,start
" cursor reset
au VimLeave * set guicursor=a:ver30-iCursor-blinkon0
" Relative line numbers & hlsearch
set number relativenumber
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber
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
" Tab widths
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
" Prefer Prolog over Perl
augroup ftdetect_prolog
  autocmd!
  autocmd BufRead,BufNewFile *.pl set filetype=prolog
augroup END
" Language specific indents - Google C++ guide
au FileType c* setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
" Move line mappings
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Acquire sudo after opening vim
cmap w!! w !sudo tee > /dev/null %
" Python 3
let g:python3_host_prog='/usr/bin/python'

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
let g:lightline.component={'lineinfo': '%2l/%2L:%2v'}
set laststatus=2

" fzf
nnoremap <Leader><Leader>f :Files<CR>
nnoremap <Leader><Leader>b :Lines<CR>
nnoremap <Leader><Leader>gf :GFiles<CR>
nnoremap <Leader><Leader>gs :GFiles?<CR>

" vim-easymotion
map <Leader> <Plug>(easymotion-prefix)

let g:EasyMotion_smartcase=1

" Replace f
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)

" <Leader> f
map <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Replace /
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

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
\                    'go': ['golint', 'go vet', 'gotype'],
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

" Language specific ale options
let g:ale_c_clangformat_options='-style=Google'

" vim-polyglot
let g:polyglot_disabled=['latex']

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

imap <C-e> <Plug>(neosnippet_expand_or_jump)
smap <C-e> <Plug>(neosnippet_expand_or_jump)

" C/C++
let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header='/usr/lib/clang'
" Go
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" Rust
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$RUST_SRC_PATH

" vimtex
" Compile on initialization, cleanup on quit
augroup vimtex_event_1
  au!
  au User VimtexEventQuit     call vimtex#compiler#clean(0)
augroup END

 " Close viewers on quit
function! CloseViewers()
  if executable('xdotool') && exists('b:vimtex')
      \ && exists('b:vimtex.viewer') && b:vimtex.viewer.xwin_id > 0
    call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
  endif
endfunction

 augroup vimtex_event_2
  au!
  au User VimtexEventQuit call CloseViewers()
augroup END

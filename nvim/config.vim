" Set standard file encoding
set encoding=utf8
" No special per file vim overide configs
set nomodeline
" Stop word wrapping
set nowrap
 " Except on Markdown
  autocmd FileType markdown setlocal wrap
" Adjust system undo levels
set undolevels=100
" Use system clipboard
set clipboard=unnamed
" Set tab width and convert tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" Don't let Vim hide characters
set conceallevel=1
set noerrorbells
" Number gutter
set number
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

let mapleader="\<SPACE>"

" Return to last opened file
nmap <Leader><Leader> <c-^>

" Tab browsing
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR><Paste>

" Colour Scheme
colorscheme monokai
let g:airline_theme='onehalfdark'
" Plugin settings

" vim-airline
let g:airline#extensions#tabline#enabled=1
set laststatus=2

" deoplete
let g:deoplete#enable_at_startup=1

" deoplete-clang
let g:deoplete#sources#clang#libclang_path="/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header="/usr/lib/clang"


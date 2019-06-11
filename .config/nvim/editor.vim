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
set tabstop=4

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


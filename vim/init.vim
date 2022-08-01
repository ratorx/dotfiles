if (has('nvim'))
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has('termguicolors'))
	let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
	let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'
	set termguicolors
endif

set tabstop=2 shiftwidth=2 softtabstop=2 expandtab " default settings
set linebreak breakindent " line breaks
set splitbelow splitright " saner splits
set cursorline " highlight cursor line
set ignorecase smartcase " ignore case unless uppercase
set wildmode=longest:full,full " ZSH style completion
set foldmethod=indent foldlevel=99 " use indents; start unfolded
set noshowmode noshowcmd " hide info on cmdline
set mouse=a " mouse in all modes
set inccommand=nosplit " incremental command preview
set title " set terminal title
set completeopt=menuone,noinsert,noselect " better completion experience
set shortmess+=c
set conceallevel=2
set hidden
set signcolumn=yes
set laststatus=3

let g:netrw_altfile=1
let g:netrw_fastbrowse=0

" relative numbering
set number relativenumber
augroup relnum
  autocmd!
  autocmd InsertEnter * setlocal norelativenumber
  autocmd InsertLeave * setlocal relativenumber
augroup END

" no terminal numbers
augroup notermnum
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" persistent undo
let s:undodir= stdpath('cache') . '/nvim'
exe 'set undodir=' . s:undodir . ' undofile'

" fix cursor when leaving Vim
augroup cursorfix
  autocmd!
  autocmd VimLeave * set guicursor=a:ver25
augroup END

" auto create non-existent directories
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre,FilterWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Mappings
" mapleader doesn't work because this is executed after plugins
" instead add space as an alias to the default leader (\) and get rid of
" localleader
map <space> <leader>
" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
" use visual traversal by default
nnoremap j gj
nnoremap k gk
" buffers
noremap <Tab> :b#<CR>
noremap <A-]> :bnext<CR>
noremap <A-[> :bprev<CR>
" splits
noremap <A-h> <C-w><C-h>
noremap <A-j> <C-w><C-j>
noremap <A-k> <C-w><C-k>
noremap <A-l> <C-w><C-l>
" save & exit
noremap <leader>w :w<CR>
noremap zz :wqall<CR>
noremap zx :qall!<CR>
" more movement
noremap H ^
noremap L $

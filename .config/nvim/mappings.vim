let mapleader="\<SPACE>"
let maplocalleader="\\"

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

 " copy paste
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P


let mapleader="\<SPACE>"
let maplocalleader="\\"

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" buffers
nnoremap <Tab> :b#<CR>
nnoremap <A-]> :bnext<CR>
nnoremap <A-[> :bprev<CR>

" splits
nnoremap <A-h> <C-w><C-h>
nnoremap <A-j> <C-w><C-j>
nnoremap <A-k> <C-w><C-k>
nnoremap <A-l> <C-w><C-l>

" exit
nnoremap zz :wqall<CR>
nnoremap zx :qall!<CR>


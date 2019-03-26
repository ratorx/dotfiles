let mapleader="\<SPACE>"
let maplocalleader="\\"

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Navigate buffers with TAB
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>

" vim-move
let g:move_key_modifier = 'C'

" suda.vim
cmap w!! w suda://%

" fzf.vim
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-j': 'split',
      \ 'ctrl-l': 'vsplit' }

nnoremap <C-g> :BLines<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-S-o> :BTags<CR>
nnoremap <C-f> :Rg 
nnoremap <C-e> <Plug>(fzf-quickfix)

" deoplete.nvim
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

" NERDTree
map <A-0> :NERDTreeToggle<CR>

" neosnippet
imap <C-e> <Plug>(neosnippet_expand_or_jump)
smap <C-e> <Plug>(neosnippet_expand_or_jump)

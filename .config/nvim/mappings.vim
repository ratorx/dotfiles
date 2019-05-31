let mapleader="\<SPACE>"
let maplocalleader="\\"

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" MRU buffer
nnoremap <Tab> :b#<CR>
" Sequential
nnoremap <A-]> :bnext<CR>
nnoremap <A-[> :bprev<CR>

" Navigate splits
nnoremap <A-h> <C-w><C-h>
nnoremap <A-j> <C-w><C-j>
nnoremap <A-k> <C-w><C-k>
nnoremap <A-l> <C-w><C-l>

nnoremap zz :wqall<CR>
nnoremap zx :qall!<CR>

" vim-move
let g:move_key_modifier = 'C'

" suda.vim
cmap w!! w suda://%

" fzf.vim
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-j': 'split',
      \ 'ctrl-l': 'vsplit' }

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :BLines<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>n :BTags<CR>
nnoremap <leader>f :Rg<Space>
nmap <leader>e <Plug>(fzf-quickfix)
nnoremap _ :TagbarOpenAutoClose<CR>

" Language Client
function! s:language_client_enter()
  nnoremap <buffer> <F2> :call LanguageClient_textDocument_rename()<CR>
  nnoremap <buffer> gd :call LanguageClient_textDocument_definition()<CR>
endfunction

augroup languageclient
  au!
  au FileType rust call <SID>language_client_enter()
augroup END


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
return !col || getline('.')[col - 1]  =~? '\s'
endfunction"}}}

" neosnippet
imap <C-e> <Plug>(neosnippet_expand_or_jump)
smap <C-e> <Plug>(neosnippet_expand_or_jump)

if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

call dein#begin('~/.local/share/dein/')
call dein#add('Shougo/dein.vim')

" Plugins 
call dein#add('Shougo/unite.vim')

" Git
call dein#add('airblade/vim-gitgutter')

" Colorscheme
call dein#add('sonph/onehalf', {"rtp": "vim"})
call dein#add('crusoexia/vim-monokai')

" Modeline
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" Completion
call dein#add('Shougo/deoplete.nvim')
call deoplete#enable()
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif
" Completion plugins
call dein#add('zchee/deoplete-clang')

call dein#end()
call dein#save_state()

" External
set rtp+=/usr/share/vim/vimfiles
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

filetype plugin indent on
syntax enable

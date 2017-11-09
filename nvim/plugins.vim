if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

call dein#begin('~/.local/share/dein/')
call dein#add('Shougo/dein.vim')

" Plugins 
" call dein#add('Shougo/unite.vim')

" Git
call dein#add('airblade/vim-gitgutter')

" Colorscheme
call dein#add('crusoexia/vim-monokai')

" Modeline
call dein#add('vim-airline/vim-airline')
call dein#add('rcabralc/monokai-airline.vim')
" call dein#add('vim-airline/vim-airline-themes')

" Finder
call dein#add('junegunn/fzf', {'build': './install --bin', 'merged': 0})
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})

call dein#end()
call dein#save_state()

filetype plugin indent on
syntax enable

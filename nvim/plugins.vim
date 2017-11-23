if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

call dein#begin('~/.local/share/dein/')
call dein#add('Shougo/dein.vim')

" Git
call dein#add('airblade/vim-gitgutter')

" Colorscheme
call dein#add('joshdick/onedark.vim')

" Modeline
call dein#add('itchyny/lightline.vim')
call dein#add('mgee/lightline-bufferline', {'depends': 'lightline.vim'})
call dein#add('maximbaz/lightline-ale', {'depends': ['lightline.vim', 'ale']})

" Finder
call dein#add('junegunn/fzf', {'build': './install --bin', 'merged': 0})
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})

" Auto-brackets
call dein#add('jiangmiao/auto-pairs')

" Comments
call dein#add('tpope/vim-commentary')

" Easy Motions
call dein#add('easymotion/vim-easymotion')

" Better Syntax Highlighting
call dein#add('sheerun/vim-polyglot')

" Linting
call dein#add('w0rp/ale')

" Completion
call dein#add('Shougo/deoplete.nvim', {'lazy': 1, 'on_ft': ['c', 'cpp', 'go', 'python', 'rust', 'tex']})

" Completion Plugins
call dein#add('zchee/deoplete-go', {'build': 'make', 'lazy': 1, 'on_ft': 'go'})
call dein#add('zchee/deoplete-jedi', {'lazy': 1, 'on_ft': 'python'})
call dein#add('zchee/deoplete-clang', {'lazy': 1, 'on_ft': ['c', 'cpp']})
call dein#add('sebastianmarkow/deoplete-rust', {'lazy': 1, 'on_ft': 'rust'})

" vimtex
call dein#add('lervag/vimtex', {'lazy': 1, 'on_ft': 'tex'})

" Snippets
call dein#add('Shougo/neosnippet', {'lazy': 1, 'on_ft': 'tex'})
call dein#add('Shougo/neosnippet-snippets', {'lazy': 1, 'on_ft': 'tex'})

call dein#end()
call dein#save_state()


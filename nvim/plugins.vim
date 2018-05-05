if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

call dein#begin('~/.local/share/dein/')
call dein#add('Shougo/dein.vim')

" Vim Improvements
call dein#add('jiangmiao/auto-pairs') " Auto-brackets
call dein#add('tpope/vim-commentary') " Auto comments
call dein#add('tpope/vim-surround')   " Surround text
call dein#add('tpope/vim-repeat')     " . support for plugins

" Git integration
call dein#add('airblade/vim-gitgutter')

" Color scheme
call dein#add('joshdick/onedark.vim')

" Modeline
call dein#add('itchyny/lightline.vim')
call dein#add('mgee/lightline-bufferline', {'depends': 'lightline.vim'})
call dein#add('maximbaz/lightline-ale', {'depends': ['lightline.vim', 'ale']})

" Fuzzy finder
call dein#add('junegunn/fzf', {'merged': 0})
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})

" Syntax highlighting for additional languages
call dein#add('sheerun/vim-polyglot', {'build': './build'})

" Linting
call dein#add('w0rp/ale')

" Completions
call dein#add('Shougo/deoplete.nvim', {'lazy': 1, 'on_ft': ['c', 'cpp', 'go', 'python', 'rust', 'tex']})
if !has('nvim')
   call dein#add('roxma/nvim-yarp')
   call dein#add('roxma/vim-hug-neovim-rpc')
endif

call dein#add('zchee/deoplete-go', {'build': 'make', 'lazy': 1, 'on_ft': 'go'})
call dein#add('zchee/deoplete-jedi', {'lazy': 1, 'on_ft': 'python'})
call dein#add('zchee/deoplete-clang', {'lazy': 1, 'on_ft': ['c', 'cpp']})
call dein#add('sebastianmarkow/deoplete-rust', {'lazy': 1, 'on_ft': 'rust'})

" Latex
call dein#add('lervag/vimtex', {'lazy': 1, 'on_ft': 'tex'})

" Markdown
call dein#add('shime/vim-livedown', {'lazy': 1, 'on_ft': 'markdown'})

" Snippets
call dein#add('Shougo/neosnippet', {'depends': 'neosnippet-snippets'})
call dein#add('Shougo/neosnippet-snippets')

call dein#end()
call dein#save_state()


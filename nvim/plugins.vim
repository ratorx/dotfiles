if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.local/share/dein')
  call dein#begin('~/.local/share/dein')
  call dein#add('Shougo/dein.vim') " Plugin Manager
  call dein#add('wsdjeg/dein-ui.vim') " Update UI

  " Interface
  call dein#add('itchyny/lightline.vim') " Modeline
  call dein#add('maximbaz/lightline-ale', {'depends': ['lightline.vim', 'ale']}) " ALE Integration
  call dein#add('rakr/vim-one') " Color Scheme
  call dein#add('majutsushi/tagbar') " Tag Browser

  " Fuzzy Finding
  call dein#add('junegunn/fzf', {'merged': 0})
  call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})

  " Improvements
  call dein#add('jiangmiao/auto-pairs') " Auto-brackets
  call dein#add('tpope/vim-surround')   " Surround textreload vim config binding
  call dein#add('tpope/vim-repeat', {'on_map': '.'})     " . support for plugins
  call dein#add('lambdalisue/suda.vim') " Save with sudo
  call dein#add('haya14busa/is.vim', {'on_map': '/'})    " Better incsearch
  call dein#add('matze/vim-move')       " Move lines around
  call dein#add('airblade/vim-rooter')  " Auto cd to project root
  call dein#add('vim-scripts/indentpython.vim') " Better indent for Python

  " Distraction free writing
  call dein#add('junegunn/goyo.vim')

  " Version Control
  call dein#add('mhinz/vim-signify')
  
  " Language Support
  call dein#add('sheerun/vim-polyglot', {'build': './build'}) " Syntax Highlighting
  call dein#add('tpope/vim-commentary') " Comments
  call dein#add('w0rp/ale') " Linting
  call dein#add('tpope/vim-sleuth') " Automatic file indent
  call dein#add('Shougo/deoplete.nvim') " Completions
  if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  " LSP
  " dein#add('prabirshrestha/async.vim')
  " dein#add('prabirshrestha/vim-lsp')
  " Snippets
  call dein#add('Shougo/neosnippet', {'depends': 'neosnippet-snippets'})
  call dein#add('Shougo/neosnippet-snippets')

  " Language Specific Plugins
  call dein#add('lervag/vimtex', {'lazy': 1, 'on_ft': 'tex'})
  call dein#add('shime/vim-livedown', {'lazy': 1, 'on_ft': 'markdown'})

  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

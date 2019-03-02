if &compatible
    set nocompatible
endif

set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.local/share/dein')
  call dein#begin('~/.local/share/dein')
  call dein#add('Shougo/dein.vim') " Plugin Manager

  " Interface
  call dein#add('itchyny/lightline.vim') " Modeline
  call dein#add('maximbaz/lightline-ale', {'depends': ['lightline.vim', 'ale']})
  call dein#add('rakr/vim-one') " Color Scheme

  " Fuzzy Finding
  call dein#add('junegunn/fzf', {'merged': 0})
  call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})

  " Improvements
  call dein#add('jiangmiao/auto-pairs') " Auto-brackets
  call dein#add('tpope/vim-surround')   " Surround text
  call dein#add('tpope/vim-repeat')     " . support for plugins
  call dein#add('lambdalisue/suda.vim') " Save with sudo
  call dein#add('haya14busa/is.vim')    " Better incsearch
  call dein#add('matze/vim-move')       " Move lines around
  call dein#add('airblade/vim-rooter')  " Auto cd to project root

  " Version Control
  call dein#add('airblade/vim-gitgutter')
  
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

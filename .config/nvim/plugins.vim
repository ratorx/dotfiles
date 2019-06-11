set runtimepath+=~/.local/share/dein/repos/github.com/Shougo/dein.vim

let s:ls_lang=['rust', 'python', 'go']
let s:other_lang=['sh', 'tex', 'vim']

if dein#load_state('~/.local/share/dein')
  call dein#begin('~/.local/share/dein')
  call dein#add('Shougo/dein.vim') " Plugin Manager
  call dein#add('wsdjeg/dein-ui.vim', {'on_cmd': 'DeinUpdate'}) " Update UI

  " Interface
  call dein#add('itchyny/lightline.vim') " Modeline
  call dein#add('rakr/vim-one') " Color Scheme
  
  call dein#add('tpope/vim-surround')   " Surround textreload vim config binding
  call dein#add('tpope/vim-repeat', {'on_map': '.'})     " . support for plugins
  call dein#add('lambdalisue/suda.vim') " Save with sudo
  call dein#add('haya14busa/is.vim', {'on_map': '/'})    " Better incsearch
  call dein#add('matze/vim-move', {'on_map': ['C-h', 'C-j', 'C-k', 'C-l']})       " Move lines around
  call dein#add('justinmk/vim-dirvish') " Directory Browser

  " Only on workstations
  " Fuzzy Finding
  call dein#add('junegunn/fzf', {'merged': 0, 'lazy': 1})
  call dein#add('junegunn/fzf.vim', {'depends': 'fzf', 'on_cmd': ['BLines', 'Files', 'BTags', 'Marks', 'Snippets', 'Rg', 'Maps', 'Buffers', 'Commands', 'Helptags', 'Filetypes']})
  call dein#add('fszymanski/fzf-quickfix', {'depends': 'fzf', 'on_map': '<Plug>(fzf-quickfix)'})

  call dein#add('airblade/vim-rooter')  " Auto cd to project root
  call dein#add('majutsushi/tagbar', {'on_cmd': ['TagbarOpen', 'TagbarClose', 'TagbarToggle', 'TagbarOpenAutoClose']}) " Tag Browser
  call dein#add('junegunn/goyo.vim', {'on_cmd': 'Goyo'}) " Distraction free writing
  call dein#add('mhinz/vim-signify') " Version Control

  " Language Support
  call dein#add('sheerun/vim-polyglot', {'build': './build'}) " Syntax Highlighting
  call dein#add('tpope/vim-commentary', {'on_map': 'gc'}) " Comments
  call dein#add('w0rp/ale', {'on_ft': s:ls_lang + s:other_lang}) " Linting
  call dein#add('tpope/vim-sleuth') " Automatic file indent
  call dein#add('Shougo/deoplete.nvim', {'lazy': 1, 'on_ft': s:ls_lang + s:other_lang}) " Completions
  call dein#add('autozimu/LanguageClient-neovim', {'branch': 'next', 'build': 'bash install.sh', 'on_ft': s:ls_lang})
  if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  " Snippets
  call dein#add('Shougo/neosnippet', {'depends': 'neosnippet-snippets'})
  call dein#add('Shougo/neosnippet-snippets')

  " Language Specific Plugins
  call dein#add('vim-scripts/indentpython.vim', {'lazy': 1, 'on_ft': 'python'}) " Better indent for Python
  call dein#add('lervag/vimtex', {'lazy': 1, 'on_ft': 'tex'})

  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

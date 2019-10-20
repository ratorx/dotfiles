scriptencoding utf8

set tabstop=2 shiftwidth=2 " default tab configuration
set linebreak breakindent " line breaks
set splitbelow splitright " saner splits
set cursorline " highlight cursor line
set ignorecase smartcase " ignore case unless uppercase
set wildmode=longest:full,full " ZSH style completion
set foldmethod=indent foldlevel=99 " use indents; start unfolded
set noshowmode noshowcmd " hide info on cmdline
set mouse=a " mouse in all modes

" python
let g:python3_host_prog='/usr/bin/python3'
let g:loaded_python_provider=0

" true color
if (has('nvim'))
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has('termguicolors'))
	let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
	let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'
	set termguicolors
endif

" relative numbering
set number relativenumber
function! EnableRelativeNumber() abort
	augroup relnum
		autocmd!
		autocmd InsertEnter * setlocal norelativenumber
		autocmd InsertLeave * setlocal relativenumber
	augroup END
endfunction
call EnableRelativeNumber()

" no terminal numbers
augroup notermnum
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" persistent undo
let s:undodir=$XDG_CACHE_HOME . '/nvim'
if !isdirectory(s:undodir)
	call mkdir(s:undodir, 'p', '0700')
endif
exe 'set undodir=' . s:undodir . ' undofile'

" fix cursor when leaving Vim
augroup cursorfix
	autocmd!
	autocmd VimLeave * set guicursor=a:ver25
augroup END

" auto create non-existent directories
function s:MkNonExDir(file, buf)
	if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
		let dir=fnamemodify(a:file, ':h')
		if !isdirectory(dir)
			call mkdir(dir, 'p')
		endif
	endif
endfunction
augroup BWCCreateDir
	autocmd!
	autocmd BufWritePre,FilterWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" misc
set conceallevel=2
set hidden

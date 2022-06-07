let g:lightline={}
let g:lightline.colorscheme='onedark'
let g:lightline.enable={'statusline': 1, 'tabline': 1}
let g:lightline.component={'lineinfo': '%2l/%2L:%2v'}
let g:lightline.active={}
let g:lightline.active.right=[['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]
let g:lightline.active.left=[['mode', 'paste'], ['readonly', 'relativepath', 'modified']]

let g:fzf_action={}
let g:fzf_action['ctrl-t']='tab split'
let g:fzf_action['ctrl-j']='split'
let g:fzf_action['ctrl-l']='vsplit'
let g:fzf_layout = {'window': '15new'}
let g:fzf_colors={}
let g:fzf_colors.fg=['fg', 'Normal']
let g:fzf_colors.bg=['bg', 'Normal']
let g:fzf_colors.hl=['fg', 'Comment']
let g:fzf_colors['fg+']=['fg', 'CursorLine', 'CursorColumn', 'Normal']
let g:fzf_colors['bg+']=['bg', 'CursorLine', 'CursorColumn']
let g:fzf_colors['hl+']=['fg', 'Statement']
let g:fzf_colors.info=['fg', 'PreProc']
let g:fzf_colors.border=['fg', 'Ignore']
let g:fzf_colors.prompt=['fg', 'Conditional']
let g:fzf_colors.pointer=['fg', 'Exception']
let g:fzf_colors.marker=['fg', 'Keyword']
let g:fzf_colors.spinner=['fg', 'Label']
let g:fzf_colors.header=['fg', 'Comment']
augroup fzf_statuslist
  au!
  au FileType fzf set laststatus=0 noruler
        \| au BufLeave <buffer> set laststatus=2 showmode ruler
augroup END
nmap <leader>b :Buffers<CR>
nmap <leader>l :Lines<CR>

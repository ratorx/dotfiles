vim.g.lightline = {
  colorscheme = 'onedark',
  enable = {
    statusline = 1,
    tabline = 1,
  },
  component = {
    lineinfo = '%2l/%2L:%2v',
  },
  active = {
    right = {{'lineinfo'}, {'fileformat', 'fileencoding', 'filetype'}},
    left = {{'mode', 'paste'}, {'readonly', 'relativepath', 'modified'}},
  },
}


require('lualine').setup({
  options = {
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },

  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'filename',
        newfile_status = true,
        path = 1,
        symbols = {
          modified = '[~]',
          readonly = '[R]',
          unnamed = '[???]',
          newfile = '[+]',
        },
      }
    },
    lualine_c = { 'diagnostics' },
    lualine_x = {},
    lualine_y = { 'encoding', 'fileformat', 'filetype' },
    lualine_z = { 'location' },
  },

  extensions = { 'quickfix' },
})

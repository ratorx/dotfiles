return {
  on_attach = function(_, bufnr)
  -- Mappings
  local bufopts = { silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gqq', function() vim.lsp.buf.format { async = true } end, bufopts)

  vim.keymap.set('n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)

  vim.keymap.set('n', '<localleader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<localleader>ca', vim.lsp.buf.code_action, bufopts)
end
}

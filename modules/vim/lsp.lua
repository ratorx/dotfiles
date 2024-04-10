local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  -- Mappings
  local bufopts = { silent = true, buffer = bufnr }
  vim.keymap.set('n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    bufopts)

  if client.server_capabilities.definitionProvider then vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts) end
  if client.server_capabilities.referencesProvider then vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts) end

  if client.server_capabilities.declarationProvider then vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts) end
  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
      bufopts)
  end
  if client.server_capabilities.implementationProvider then
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
      bufopts)
  end

  if client.server_capabilities.hoverProvider then vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts) end
  if client.server_capabilities.signatureHelpProvider then
    vim.keymap.set({ 'i', 'n' }, '<C-k>',
      vim.lsp.buf.signature_help, bufopts)
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', 'gqq',
      function() vim.lsp.buf.format { async = true } end, bufopts)
  end
  if client.server_capabilities.renameProvider then vim.keymap.set('n', '<localleader>rn', vim.lsp.buf.rename, bufopts) end
  if client.server_capabilities.codeActionProvider then
    vim.keymap.set('n', '<localleader>ca', vim.lsp.buf.code_action
    , bufopts)
  end
end


-- TODO: Investigate language servers for:
-- * Svelte (tsserver + sveltels + tailwindcssls + ???)
local lsps = {
  bashls = {},      -- Bash
  gopls = {},       -- Go
  hls = {},         -- Haskell
  lua_ls = {},      -- Lua
  ruff_lsp = {},    -- Python
  terraformls = {}, -- Terraform
  nil_ls = {
    ['nil'] = {
      formatting = { command = { "nixpkgs-fmt" } }
    }
  }, -- Nix
  rust_analyzer = {
    ['rust-analyzer'] = {
      files = { excludeDirs = { ".direnv", ".git" } }
    }
  }, -- Rust
}

for name, settings in pairs(lsps) do
  lspconfig[name].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings
  })
end

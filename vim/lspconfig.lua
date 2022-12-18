local lsp = require('lsp')

-- Used by config generated from Nix
---@diagnostic disable-next-line:unused-local
local configure_lsps = function(lsps)
  local lspconfig = require('lspconfig')
  local extra = {
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' }, disable = { 'unused-function' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
  }

  for name, cmd in pairs(lsps) do
    local cfg = extra[name] or {}
    cfg.cmd = { cmd }
    cfg.on_attach = lsp.on_attach
    lspconfig[name].setup(cfg)
  end
end

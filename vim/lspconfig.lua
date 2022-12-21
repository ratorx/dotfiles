local lsp = require('lsp')
local lspconfig = require('lspconfig')

local cfgs = {
  hls = {},
  rnix = {},
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

for name, cfg in pairs(cfgs) do
  cfg.on_attach = lsp.on_attach
  lspconfig[name].setup(cfg)
end

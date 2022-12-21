local lsp = require('lsp')
local lspconfig = require('lspconfig')

local cfgs = {
  hls = {}, -- Haskell
  rnix = {}, -- Nix
  sumneko_lua = {}, -- Lua
}

for name, cfg in pairs(cfgs) do
  cfg.on_attach = lsp.on_attach
  lspconfig[name].setup(cfg)
end

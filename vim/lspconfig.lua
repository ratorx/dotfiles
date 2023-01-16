local lsp = require('lsp')
local lspconfig = require('lspconfig')

-- TODO: Investigate language servers for:
-- * Python (maybe ruff + black + ??? for completions)
-- * Svelte (tsserver + sveltels + tailwindcssls + ???)
local cfgs = {
  gopls = {}, -- Go
  hls = {}, -- Haskell
  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = {
          command = { "nixpkgs-fmt" }
        }
      }
    }
  }, -- Nix
  rust_analyzer = {}, -- Rust
  sumneko_lua = {}, -- Lua
  terraformls = {}, -- Terraform
}

for name, cfg in pairs(cfgs) do
  cfg.on_attach = lsp.on_attach
  lspconfig[name].setup(cfg)
end

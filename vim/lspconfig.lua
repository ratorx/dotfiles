local lsp = require('lsp')
local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        files = { excludeDirs = { ".direnv", ".git" } }
      }
    }
  }, -- Rust
  lua_ls = {}, -- Lua
  terraformls = {}, -- Terraform
}

for name, cfg in pairs(cfgs) do
  cfg.on_attach = lsp.on_attach
  cfg.capabilities = capabilities
  lspconfig[name].setup(cfg)
end

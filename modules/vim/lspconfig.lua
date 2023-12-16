local lsp = require('lsp')
local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- TODO: Investigate language servers for:
-- * Svelte (tsserver + sveltels + tailwindcssls + ???)
local cfgs = {
  gopls = {},       -- Go
  hls = {},         -- Haskell
  lua_ls = {},      -- Lua
  ruff_lsp = {},    -- Python
  terraformls = {}, -- Terraform
  -- Custom Settings
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
}

for name, cfg in pairs(cfgs) do
  cfg.on_attach = lsp.on_attach
  cfg.capabilities = capabilities
  lspconfig[name].setup(cfg)
end

local null_ls = require('null-ls')
local lsp = require('lsp')
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
  },
  on_attach = lsp.on_attach,
})

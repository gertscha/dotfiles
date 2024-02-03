
-- local util = require("lspconfig/util")
-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- lspconfig.gopls.setup {
--   capabilities = lsp_capabilities,
--   cmd = {"gopls"},
--   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
-- }

-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      completeUnimported = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
    analyses = {
      unusedparams = true,
    },
  },
}

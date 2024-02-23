
-- local util = require("lspconfig/util")
-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Setup Language Servers
-- lspconfig.clangd.setup {
--   capabilities = lsp_capabilities,
-- }

-- https://clangd.llvm.org/config
return {
  filetypes = { "c", "cpp", "cc", "mpp", "ixx", "objc", "objcpp", "cuda" },
}


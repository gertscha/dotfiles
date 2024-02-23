local M = {

  {
    'williamboman/mason.nvim', -- simple to use language server installer
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded", },
    },
    event = "VeryLazy",
    config = function()
      local icons = require("settings.icons")
      require("mason").setup({
        ui = {
          icons = {
            package_installed = icons.ui.Check,
            package_pending = icons.ui.CloudDownload,
            package_uninstalled = icons.ui.Close,
          }
        }
      })
    end,
  },

  -- lsp plugins
  -- bridge the gap between lspconfig and mason
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufRead", "BufNewFile" },
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = LSP_SERVERS,
        automatic_installation = true,
      })
    end,
  },

}

return M


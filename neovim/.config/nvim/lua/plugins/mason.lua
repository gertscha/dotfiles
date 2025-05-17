local M = {
  'mason-org/mason-lspconfig.nvim',
  dependencies = {
    'mason-org/mason.nvim',
  },
  cmd = 'Mason',
}

function M.config()
  local icons = require('settings.icons')
  -- mason setup (installs lsp servers) and ui customization
  require('mason').setup({
    ui = {
      icons = {
        package_installed = icons.ui.Check,
        package_pending = icons.ui.CloudDownload,
        package_uninstalled = icons.ui.Close,
      },
    },
  })

  -- mason-lspconfig automates the lsp server setup for mason insalled servers
  -- servers not installed with Mason need to be enabled manually
  require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls' },
    automatic_enable = true,
  })

  -- manually enable a server
  -- vim.lsp.enable('lua_ls')
end

return M

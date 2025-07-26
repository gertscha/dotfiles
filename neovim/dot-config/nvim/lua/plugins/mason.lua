local M = {
  'mason-org/mason.nvim',
  cmd = 'Mason',
  lazy = false,
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
end

return M

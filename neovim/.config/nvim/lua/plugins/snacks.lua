local dashboard_settings = require('plugins.configuration.snacks-dashboard')

local M = {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  tag = 'v2.22.0',
  opts = {
    -- nicer ui for input windows (for example lsp.buf.rename)
    input = {
      enabled = true,
    },
    indent = {
      enabled = false, -- vague theme currently does not highlight properly
      only_scope = false,
      only_current = true,
    },
    dashboard = dashboard_settings,
    notifier = {
      enabled = true,
      timeout = 2000,
      height = { min = 1, max = 0.4 },
      margin = { top = 2, right = 3, bottom = 0 },
    },
    -- disable all the others explicitly (not technically needed)
    bigfile = { enabled = false },
    explorer = { enabled = false },
    picker = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}

function M.init()
  vim.keymap.set(
    'n',
    '<leader>os',
    '<cmd>lua Snacks.dashboard()<cr>',
    { desc = '[O]pen [S]plash Screen' }
  )
  vim.api.nvim_create_user_command(
    'Mes',
    'lua Snacks.notifier.show_history()<cr>',
    {}
  )
  vim.api.nvim_create_user_command(
    'Messages',
    'lua Snacks.notifier.show_history()<cr>',
    {}
  )
end

return M

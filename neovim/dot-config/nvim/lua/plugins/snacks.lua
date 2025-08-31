---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'folke/snacks.nvim', { version = 'v2.22.0' })
  end,
  priority = 'c',
}

function M.config()
  local enable_notififer = true
  require('snacks').setup({
    -- nicer ui for input windows (for example lsp.buf.rename)
    input = {
      enabled = true,
    },
    indent = {
      enabled = false,
      animate = { enabled = false },
      -- to get only current scope markers:
      -- https://github.com/folke/snacks.nvim/discussions/332
      indent = { enabled = false },
    },
    notifier = {
      enabled = enable_notififer,
      timeout = 2000,
      height = { min = 1, max = 0.4 },
      width = { min = 1, max = 0.6 },
      margin = { top = 2, right = 3, bottom = 0 },
    },
    -- dashboard configured in separate file
    dashboard = require('plugins.configuration.snacks-dashboard'),
    -- disable all the others explicitly (not technically needed)
    bigfile = { enabled = false },
    explorer = { enabled = false },
    picker = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  })

  -- dashboard settings
  vim.keymap.set(
    'n',
    '<leader>os',
    '<cmd>lua Snacks.dashboard()<cr>',
    { desc = '[O]pen [S]plash Screen' }
  )
  -- indent settings
  vim.keymap.set('n', '<leader>ti', function()
    local snacks_indent = require('snacks.indent')
    if snacks_indent.enabled then
      snacks_indent.disable()
    else
      snacks_indent.enable()
    end
  end, { desc = 'Toggle Scope Markers' })
  -- notifier settings
  if enable_notififer then
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
end

return M

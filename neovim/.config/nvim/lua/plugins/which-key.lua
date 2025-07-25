local M = {
  'folke/which-key.nvim',
  lazy = false,
  tag = 'stable',
  dependencies = {
    'echasnovski/mini.icons',
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}

function M.config()
  -- make some nicer labels for which-key
  local mod = P_require('which-key')
  if mod then
    mod.add({
      mode = 'n', -- NORMAL mode
      { 'gr', group = 'diagnostics' },
      { '<space>s', group = 'Search' },
      { '<space>l', group = 'Session Management' },
      { '<space>o', group = 'Open Screens' },
      { '<space>om', group = 'Markdown' },
      { '<space>t', group = 'Toggle' },
      { '<space>tw', group = 'Line width settings' },
      { '<space>ts', group = 'Command line visibility toggle' },
      { '<leader>d', group = 'diagnostics' },
      { '<leader>dc', group = '[c]all hierarchy' },
      { '<leader>dr', group = 'Restart/Reset LSP functionality' },
      { '<leader>dg', group = 'default LSP g binds' },
      { '<leader>dgr', group = 'default LSP gr binds' },
    })
  end
end

return M

return {
  'j-hui/fidget.nvim',
  priority = 1000,
  tag = 'v1.6.1',
  opts = {
    notification = {
      history_size = 256,
      override_vim_notify = true,
      window = {
        winblend = 0, -- 100 full transparency, 0 no transparency
        border = 'single',
        align = 'top',
        x_padding = 3,
        y_padding = 2,
        max_width = 50,
      },
      view = {
        stack_upwards = 'false',
      },
    },
    progress = {
      ignore_done_already = true,
      display = {
        done_ttl = 10,
      },
    },
    logger = {
      level = vim.log.levels.INFO, -- Minimum logging level
      max_size = 10000,
      float_precision = 0.01, -- Limit the number of decimals displayed for floats
      path = string.format('%s/fidget.nvim.log', vim.fn.stdpath('log')),
    },
  },
  init = function()
    vim.api.nvim_create_user_command('Mes', 'Fidget history', {})
    vim.api.nvim_create_user_command('Messages', 'Fidget history', {})
  end,
}

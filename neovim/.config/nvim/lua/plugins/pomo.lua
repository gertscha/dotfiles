local M = {
  'epwalsh/pomo.nvim',
  enabled = false,
  version = '*', -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { 'TimerStart', 'TimerRepeat' },
  dependencies = {
    'rcarriga/nvim-notify',
  },
  opts = {
    update_interval = 1000,
    notifiers = {
      -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
      {
        name = 'Default',
        opts = {
          -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
          -- continuously displayed. If you only want a pop-up notification when the timer starts
          -- and finishes, set this to false.
          sticky = false,
          title_icon = '󱎫',
          text_icon = '󰄉',
        },
      },
      -- The "System" notifier sends a system notification when the timer is finished.
      -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
      { name = 'System' },
    },
  },
}

function M.config()
  require('which-key').add({
    mode = 'n', -- NORMAL mode
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>t', group = 'PomoTimer' },
    -- s = { 'START?', 'Start normal pomodoro cycle' },
    -- l = { 'START?', 'Start a pomodoro cycle with a long break' },
    -- p = { 'PAUSE?', 'Pause all pomodoro cycles' },
    -- x = { 'TERMINATE?', 'terminate all pomodoro cycles' },
  })
end

return M

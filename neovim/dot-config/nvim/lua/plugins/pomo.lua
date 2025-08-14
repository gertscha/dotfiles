local M = {
  -- Never really used this, as it does not quite behave the way I want it
  'epwalsh/pomo.nvim',
  enabled = false,
  version = '*', -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { 'TimerStart', 'TimerRepeat' },
  keys = { '<leader>tp' },
  opts = {
    update_interval = 1000,
    notifiers = {
      {
        name = 'snacks',
        opts = {
          -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
          -- continuously displayed. If you only want a pop-up notification when the timer starts
          -- and finishes, set this to false.
          sticky = false,
          title_icon = '󱎫',
          text_icon = '󰄉',
        },
      },
    },
    sessions = {
      pomodoro = {
        { name = 'Work', duration = '25m' },
        { name = 'Short Break', duration = '5m' },
        { name = 'Work', duration = '25m' },
        { name = 'Short Break', duration = '5m' },
        { name = 'Work', duration = '25m' },
        { name = 'Long Break', duration = '20m' },
        { name = 'Work', duration = '25m' },
        { name = 'Short Break', duration = '5m' },
      },
    },
  },
}

function M.config()
  require('which-key').add({
    mode = 'n', -- NORMAL mode
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>tp', group = 'PomoTimer' },
    s = { 'START?', 'Start normal pomodoro cycle' },
    l = { 'START?', 'Start a pomodoro cycle with a long break' },
    p = { 'PAUSE?', 'Pause all pomodoro cycles' },
    x = { 'TERMINATE?', 'terminate all pomodoro cycles' },
  })
end

return M

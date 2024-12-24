local M = {
  "epwalsh/pomo.nvim",
  version = "*",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    update_interval = 1000,
    notifiers = {
      -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
      {
        name = "Default",
        opts = {
          -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
          -- continuously displayed. If you only want a pop-up notification when the timer starts
          -- and finishes, set this to false.
          sticky = false,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
      -- The "System" notifier sends a system notification when the timer is finished.
      -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
      { name = "System" },
    },
  },
}


function M.config()
  -- which-key setup this is the default
  local kopts = {
    mode = 'n', -- NORMAL mode
    prefix = '', -- the prefix is prepended to every mapping part of `mappings`
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }
  require('which-key').register({
    ['<leader>'] = {
      t = {
        name = 'PomoTimer',
        -- s = { 'START?', 'Start normal pomodoro cycle' },
        -- l = { 'START?', 'Start a pomodoro cycle with a long break' },
        -- p = { 'PAUSE?', 'Pause all pomodoro cycles' },
        -- x = { 'TERMINATE?', 'terminate all pomodoro cycles' },
      },
    },
  }, kopts)

end


return M

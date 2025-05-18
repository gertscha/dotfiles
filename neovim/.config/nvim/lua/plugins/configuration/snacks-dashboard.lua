local function getGreeting(name)
  local tableTime = os.date('*t')
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = '  Sleep well',
    [2] = '  Good morning',
    [3] = '  Good afternoon',
    [4] = '  Good evening',
    [5] = '  Good night',
  }
  local greetingIndex = 0
  if hour >= 24 or hour <= 5 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 17 then
    greetingIndex = 3
  elseif hour >= 17 and hour < 22 then
    greetingIndex = 4
  elseif hour >= 22 then
    greetingIndex = 5
  end
  return greetingsTable[greetingIndex] .. ', ' .. name
end

local M = {
  enabled = true,
  sections = {
    { section = 'header' },
    {
      title = getGreeting('Alexander'),
      align = 'center',
      indent = 1,
      padding = 1,
    },
    -- {
    --   tile = lazystats(),
    --   align = 'center',
    --   indent = 1,
    --   padding = 1,
    -- },
    {
      section = 'startup',
      padding = 2,
    },
    {
      title = 'Most Recently Used',
      align = 'center',
      indent = 1,
      padding = 1,
    },
    {
      section = 'recent_files',
      indent = 1,
      limit = 6,
      padding = 1,
    },
    {
      title = 'Projects',
      gap = 1,
      indent = 1,
      align = 'center',
      padding = 1,
    },
    {
      section = 'projects',
      limit = 3,
      indent = 1,
      padding = 1,
    },
    {
      title = 'Quick Links',
      gap = 1,
      indent = 1,
      align = 'center',
      padding = 1,
    },
    {
      section = 'keys',
      indent = 1,
      padding = 1,
    },
  },
  autokeys = '123456ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  width = 61,
  formats = {
    header = {
      '%s',
      hl = 'DiffAdd',
    },
    title = {
      '%s',
      hl = 'SpecialComment',
    },
  },
  preset = {
    header = [[
_____________________________________________________
 ______________________/\\\___________________________
  ________/\\\____/\\\_\///_____/\\\\\__/\\\\\_________
   _______\//\\\__/\\\___/\\\__/\\\///\\\\\///\\\_______
    ________\//\\\/\\\___\/\\\_\/\\\_\//\\\__\/\\\_______
     _________\//\\\\\____\/\\\_\/\\\__\/\\\__\/\\\_______
      __________\//\\\_____\/\\\_\/\\\__\/\\\__\/\\\_______
       ___________\///______\///__\///___\///___\///________
        _____________________________________________________
]],
    keys = {
      {
        icon = '',
        key = 'f',
        desc = 'Find File',
        action = ":lua Snacks.dashboard.pick('files')",
      },
      {
        icon = '',
        key = 'n',
        desc = 'New File',
        action = ':ene | startinsert',
      },
      -- {
      --   icon = ' ',
      --   key = 'g',
      --   desc = 'Find Text',
      --   action = ":lua Snacks.dashboard.pick('live_grep')",
      -- },
      -- {
      --   icon = ' ',
      --   key = 'r',
      --   desc = 'Recent Files',
      --   action = ":lua Snacks.dashboard.pick('oldfiles')",
      -- },
      {
        icon = '',
        key = 'c',
        desc = 'Configuration',
        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
      },
      {
        icon = '',
        key = 'u',
        desc = 'Update Plugins',
        action = ':Lazy',
        enabled = package.loaded.lazy ~= nil,
      },
      {
        icon = '',
        key = 's',
        desc = 'Load Session',
        action = ':source Session.nvim<CR>',
      },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
}

return M

-- this is a combination with slight adjustments of the example themes
-- included in the themes folder of the alpha plugin (dashboard and startify)

local displayName = 'Alexander'
local target_width = 60

local icons = require('settings.icons')

local utils = require('alpha.utils')
local dashboard = require('alpha.themes.dashboard')
local startify = require('alpha.themes.startify')


-- Helper functions

-- function taken from lualine, shortens path by turning apple/orange -> a/orange
---@param path string
---@param sep string path separator
---@param max_len integer maximum length of the full filename string
---@return string
local function shorten_path(path, sep, max_len)
  local len = #path
  if len <= max_len then
    return path
  end
  local segments = vim.split(path, sep)
  for idx = 1, #segments - 1 do
    if len <= max_len then
      break
    end
    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
    segments[idx] = shortened
    len = len - (#segment - #shortened)
  end
  return table.concat(segments, sep)
end

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

local function set_width(element)
  element.opts.width = target_width
  return element
end

-- adapted from the startify.file_button function
local function file_button(fn, sc, short_fn, autocd)
  short_fn = vim.F.if_nil(short_fn, fn)
  local ico_txt
  local fb_hl = {}
  local file_icons = startify.file_icons
  if file_icons.enabled then
    local ico, hl = startify.icon(fn)
    local hl_option_type = type(file_icons.highlight)
    if hl_option_type == "boolean" then
      if hl and file_icons.highlight then
        table.insert(fb_hl, { hl, 0, #ico })
      end
    end
    if hl_option_type == "string" then
      table.insert(fb_hl, { file_icons.highlight, 0, #ico })
    end
    ico_txt = ico .. "  "
  else
    ico_txt = ""
  end
  local cd_cmd = (autocd and " | cd %:p:h" or '')
  local file_button_el = dashboard.button(sc, ico_txt .. short_fn,
    '<cmd>e ' .. vim.fn.fnameescape(fn) .. cd_cmd .. ' <CR>')
  local fn_start = short_fn:match(".*[/\\]")
  if fn_start ~= nil then
    table.insert(fb_hl, { 'Comment', #ico_txt, #fn_start + #ico_txt })
  end
  file_button_el.opts.hl = fb_hl
  return set_width(file_button_el)
end

-- adapted from the startify.mru function
local function mru(start, cwd, items_number, opts)
  opts = opts or startify.mru_opts
  items_number = vim.F.if_nil(items_number, 10)
  local oldfiles = {}
  for _, v in pairs(vim.v.oldfiles) do
    if #oldfiles == items_number then
      break
    end
    local cwd_cond
    if not cwd then
      cwd_cond = true
    else
      cwd_cond = vim.startswith(v, cwd)
    end
    local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
    if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
      oldfiles[#oldfiles + 1] = v
    end
  end
  local tbl = {}
  for i, fn in ipairs(oldfiles) do
    local short_fn
    if cwd then
      short_fn = vim.fn.fnamemodify(fn, ":.")
    else
      short_fn = vim.fn.fnamemodify(fn, ":~")
    end
    if #short_fn > target_width - 7 then
      short_fn = shorten_path(short_fn, '/', target_width - 7)
    end
    local shortcut = tostring(i + start - 1)
    -- local shortcut = ''
    -- local special_shortcuts = { 'a', 's', 'd', 'e' }
    -- if i <= #special_shortcuts then
    --   shortcut = special_shortcuts[i]
    -- else
    --   shortcut = tostring(i + start - 1 - #special_shortcuts)
    -- end
    local file_button_el = file_button(fn, shortcut, short_fn, opts.autocd)
    tbl[i] = file_button_el
  end
  return {
    type = "group",
    val = tbl,
    opts = {},
  }
end


-- The components

local header = {
  type = 'text',
  -- this is Slant Relief Ascii text
  val = {
    [[_____________________________________________________        ]],
    [[ ______________________/\\\___________________________       ]],
    [[  ________/\\\____/\\\_\///_____/\\\\\__/\\\\\_________      ]],
    [[   _______\//\\\__/\\\___/\\\__/\\\///\\\\\///\\\_______     ]],
    [[    ________\//\\\/\\\___\/\\\_\/\\\_\//\\\__\/\\\_______    ]],
    [[     _________\//\\\\\____\/\\\_\/\\\__\/\\\__\/\\\_______   ]],
    [[      __________\//\\\_____\/\\\_\/\\\__\/\\\__\/\\\_______  ]],
    [[       ___________\///______\///__\///___\///___\///________ ]],
    [[        _____________________________________________________]],
  },
  opts = {
    position = 'center',
    hl = 'DiffAdd',
    wrap = 'overflow',
  },
}

local greeting = {
  type = 'text',
  val = getGreeting(displayName),
  opts = {
    position = 'center',
    hl = 'Statement',
  },
}

local stats = require('lazy').stats()
local plugins = {
  type = 'text',
  val = { '⚡ Neovim loaded ' .. stats.count .. ' plugins ' },
  opts = {
    position = 'center',
    hl = 'String',
  },
  { type = 'padding', val = 1 },
  position = 'center',
}

local mru_cwd = {
  type = "group",
  val = {
    { type = 'padding', val = 1 },
    {
      type = "text",
      val = 'Most Recently Used',
      opts = { hl = "SpecialComment", position = 'center' }
    },
    -- { -- does not work as expected if :cd is used
    --   type = "text",
    --   val = shorten_path(vim.fn.getcwd(), '/', target_width),
    --   opts = { hl = "SpecialComment", position = 'center' }
    -- },
    { type = "padding", val = 1 },
    {
      type = "group",
      -- mru args are: start val, cwd, elem count
      val = function() return { mru(1, vim.fn.getcwd(), 9) } end,
      opts = { shrink_margin = false },
    },
  },
}

local set_path_config = '<cmd>cd' .. vim.fn.stdpath('config') .. '<CR>'
local quick_actions = {
  type = 'group',
  val = {
    { type = 'text',    val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
    { type = 'padding', val = 1 },
    set_width(dashboard.button('f', icons.ui.FileFilled .. '  Find file', '<cmd>FzfLua files<CR>')),
    set_width(dashboard.button('n', icons.ui.NewFile .. '  New file', ':ene <BAR> startinsert <CR>')),
    set_width(dashboard.button('c', icons.ui.GearFilled .. '  Configuration', set_path_config)),
    set_width(dashboard.button('u', icons.ui.HatCircleUp .. '  Update plugins', ':Lazy<CR>')),
    set_width(dashboard.button('s', icons.ui.BookMark .. '  Load Session', ':source Session.nvim<CR>')),
    set_width(dashboard.button('q', icons.ui.Exit .. '  Quit', ':qa<CR>')),
  },
  position = 'center',
}

local footer = {
  type = 'group',
  val = {},
  position = 'center',
}


local section = {
  header = header,
  greeting = greeting,
  plugins = plugins,
  top_buttons = mru_cwd,
  bottom_buttons = quick_actions,
  footer = footer,
}

local config = {
  layout = {
    { type = 'padding', val = 1 },
    section.header,
    { type = 'padding', val = 2 },
    section.greeting,
    { type = 'padding', val = 1 },
    section.plugins,
    { type = 'padding', val = 1 },
    section.top_buttons,
    { type = 'padding', val = 1 },
    section.bottom_buttons,
    { type = 'padding', val = 1 },
    section.footer,
  },
  opts = {
    margin = 3,
    redraw_on_resize = true,
    setup = function()
      vim.api.nvim_create_autocmd('DirChanged', {
        pattern = '*',
        group = 'alpha_temp',
        callback = function()
          require('alpha').redraw()
          vim.cmd('AlphaRemap')
        end,
      })
    end,
  },
}

return {
  file_icons = { provider = 'mini' },
  section = section,
  config = config,
  leader = dashboard.leader,
}

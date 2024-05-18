-- based on the startify.lua base theme

local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

 -- string: replaces `leader` "leader" in the button keymaps.
 -- note: does not replace how it's displayed, so you'll want to
 -- redfine the `dashboard.section.buttons.val` table
local leader = 'SPC' -- leader key is not used for anything

local userName = 'Alexander'


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
    hl = 'CustomHeaderColor'
  },
}

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")
  local opts = {
    position = 'left',
    shortcut = '  ' .. sc,
    cursor = 1,
    -- width = 50,
    align_shortcut = 'right',
    hl_shortcut = { { 'Operator', 0, 1 }, { 'Number', 1, #sc + 1 }, { 'Operator', #sc + 1, #sc + 2 } },
    shrink_margin = false,
  }
  if keybind then
    keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { 'n', sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

local nvim_web_devicons = {
  enabled = true,
  highlight = true,
}

local function get_extension(fn)
  local match = fn:match("^.+(%..+)$")
  local ext = ''
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local function icon(fn)
  local nwd = require('nvim-web-devicons')
  local ext = get_extension(fn)
  return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(fn, sc, short_fn, autocd)
  short_fn = if_nil(short_fn, fn)
  local ico_txt
  local fb_hl = {}
  if nvim_web_devicons.enabled then
    local ico, hl = icon(fn)
    local hl_option_type = type(nvim_web_devicons.highlight)
    if hl_option_type == 'boolean' then
      if hl and nvim_web_devicons.highlight then
        table.insert(fb_hl, { hl, 0, #ico })
      end
    end
    if hl_option_type == 'string' then
      table.insert(fb_hl, { nvim_web_devicons.highlight, 0, #ico })
    end
    ico_txt = ico .. '  '
  else
    ico_txt = ''
  end
  local dashboard = require('alpha.themes.dashboard')
  local cd_cmd = (autocd and " | cd %:p:h" or '')
  local file_button_el = dashboard.button(sc, ico_txt .. short_fn, '<cmd>e ' .. vim.fn.fnameescape(fn) .. cd_cmd ..' <CR>')
  local fn_start = short_fn:match(".*[/\\]")
  if fn_start ~= nil then
    table.insert(fb_hl, { 'Comment', #ico_txt, #fn_start + #ico_txt })
  end
  file_button_el.opts.hl = fb_hl
  return file_button_el
end

local default_mru_ignore = { 'gitcommit' }

local mru_opts = {
  ignore = function(path, ext)
    return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
  end,
  autocd = false
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
  opts = opts or mru_opts
  items_number = if_nil(items_number, 8)
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
    local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
    if (filereadable(v) == 1) and cwd_cond and not ignore then
      oldfiles[#oldfiles + 1] = v
    end
  end

  local target_width = 45
  local special_shortcuts = { 'a', 's', 'd', 'e' }
  local path = require('plenary.path')
  local tbl = {}
  for i, fn in ipairs(oldfiles) do
    local short_fn
    if cwd then
      short_fn = fnamemodify(fn, ":.")
    else
      short_fn = fnamemodify(fn, ":~")
    end

    if #short_fn > target_width then
      short_fn = path.new(short_fn):shorten(1, { -2, -1 })
      if #short_fn > target_width then
        short_fn = path.new(short_fn):shorten(1, { -1 })
      end
    end

    local shortcut = ''
    if i <= #special_shortcuts then
      shortcut = special_shortcuts[i]
    else
      shortcut = tostring(i + start - 1 - #special_shortcuts)
    end

    local file_button_el = file_button(fn, shortcut, short_fn,opts.autocd)
    tbl[i] = file_button_el
  end
  return {
    type = 'group',
    val = tbl,
    opts = {},
  }
end


local greeting = getGreeting(userName)
local dashboard = require('alpha.themes.dashboard')
local stats = require('lazy').stats()


local section = {
  header = header,
  greeting = {
    type = 'text',
    val = greeting,
    opts = {
      position = 'center',
      hl = 'String',
    },
  },
  lazy = {
    type = 'text',
    val = { '⚡ Neovim loaded ' .. stats.count .. ' plugins ' },
    opts = {
      position = 'center',
      hl = 'Comment',
    },
    { type = 'padding', val = 1 },
    position = 'center',
  },
  mru_cwd = {
    type = 'group',
    val = {
      { type = 'padding', val = 1 },
      {
        type = 'text',
        val = 'Most Recently Used',
        opts = {
          hl = 'SpecialComment',
          shrink_margin = false,
          position = 'center',
        }
      },
      -- {
      --     type = 'text',
      --     val = '' .. vim.fn.getcwd(),
      --     opts = {
      --         hl = 'SpecialComment',
      --         shrink_margin = false,
      --         position = 'center',
      --     }
      -- },
      { type = 'padding', val = 1 },
      {
        type = 'group',
        val = function()
          return { mru(1, vim.fn.getcwd()) }
        end,
        opts = {
          shrink_margin = false,
        },
      },
    },
    position = 'center',
  },
  bottom_buttons = {
    type = 'group',
    val = {
      { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
      { type = 'padding', val = 1 },
      dashboard.button('f', '  Find file', '<cmd>Telescope find_files<CR>'),
      dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('c', '  Configuration', function() vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua') end),
      dashboard.button('u', '  Update plugins', ':Lazy<CR>'),
      dashboard.button('q', '󰗼  Quit', ':qa<CR>'),
    },
    position = 'center',
  },
  footer ={
    type = 'group',
    val = {},
    position = 'center',
  },
}

-- function() require('telescope.builtin').find_files({'cwd':configdir}) end

local config = {
  layout = {
    { type = 'padding', val = 1 },
    section.header,
    { type = 'padding', val = 2 },
    section.greeting,
    { type = 'padding', val = 1 },
    section.lazy,
    { type = 'padding', val = 1 },
    section.mru_cwd,
    { type = 'padding', val = 1 },
    section.bottom_buttons,
    { type = 'padding', val = 1 },
    section.footer,
  },
  opts = {
    margin = 3,
    redraw_on_resize = false,
    setup = function()
      vim.api.nvim_create_autocmd('DirChanged', {
        pattern = '*',
        group = 'alpha_temp',
        callback = function ()
          require('alpha').redraw()
          vim.cmd('AlphaRemap')
        end,
      })
    end,
  },
}

return {
  icon = icon,
  button = button,
  file_button = file_button,
  mru = mru,
  mru_opts = mru_opts,
  section = section,
  config = config,
  -- theme config
  nvim_web_devicons = nvim_web_devicons,
  leader = leader,
  -- deprecated
  opts = config,
}

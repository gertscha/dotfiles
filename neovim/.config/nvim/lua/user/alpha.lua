-- a much simpler plugin:
-- return {
--   'eoh-bse/minintro.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('minintro').setup({ color = '#98c379' })
--   end,
-- }

-- start screen
local M = {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
  },
  config = function()

    local path = require('plenary.path')
    local dashboard = require('alpha.themes.dashboard')
    local nvim_web_devicons = require('nvim-web-devicons')
    local cdir = vim.fn.getcwd()

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
      if hour == 23 or hour < 7 then
        greetingIndex = 1
      elseif hour < 12 then
        greetingIndex = 2
      elseif hour >= 12 and hour < 18 then
        greetingIndex = 3
      elseif hour >= 18 and hour < 21 then
        greetingIndex = 4
      elseif hour >= 21 then
        greetingIndex = 5
      end
      return greetingsTable[greetingIndex] .. ', ' .. name
    end

    local userName = 'Alexander'
    local greeting = getGreeting(userName)

    local greetHeading = {
      type = 'text',
      val = greeting,
      opts = {
        position = 'center',
        hl = 'String',
      },
    }

    local function get_extension(fn)
      local match = fn:match('^.+(%..+)$')
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

    local function file_button(fn, sc, short_fn)
      short_fn = short_fn or fn
      local ico_txt
      local fb_hl = {}

      local ico, hl = icon(fn)
      local hl_option_type = type(nvim_web_devicons.highlight)
      if hl_option_type == 'boolean' then
        if hl and nvim_web_devicons.highlight then
          table.insert(fb_hl, { hl, 0, 1 })
        end
      end
      if hl_option_type == 'string' then
        table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
      end
      ico_txt = ico .. '  '

      local file_button_el = dashboard.button(sc, ico_txt .. short_fn, '<cmd>e ' .. fn .. ' <CR>')
      local fn_start = short_fn:match('.*/')
      if fn_start ~= nil then
        table.insert(fb_hl, { 'Comment', #ico_txt - 2, #fn_start + #ico_txt - 2 })
      end
      file_button_el.opts.hl = fb_hl
      return file_button_el
    end

    local default_mru_ignore = { 'gitcommit' }

    local mru_opts = {
      ignore = function(path, ext)
        return (string.find(path, 'COMMIT_EDITMSG')) or (vim.tbl_contains(default_mru_ignore, ext))
      end,
    }

    --- @param start number
    --- @param cwd string optional
    --- @param items_number number optional number of items to generate, default = 10
    local function mru(start, cwd, items_number, opts)
      opts = opts or mru_opts
      items_number = items_number or 9

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
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
          oldfiles[#oldfiles + 1] = v
        end
      end

      local special_shortcuts = { 'a', 's', 'd' }
      local target_width = 35

      local tbl = {}
      for i, fn in ipairs(oldfiles) do
        local short_fn
        if cwd then
          short_fn = vim.fn.fnamemodify(fn, ':.')
        else
          short_fn = vim.fn.fnamemodify(fn, ':~')
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

        local file_button_el = file_button(fn, ' ' .. shortcut, short_fn)
        tbl[i] = file_button_el
      end
      return {
        type = 'group',
        val = tbl,
        opts = {},
      }
    end

    -- Ascii fonts that look decent:
    --  3D-ASCII
    --  Alligator2
    --  Merlin1
    --  Crawford
    --  Larry 3D
    --
    -- this is: Larry 3D
    -- val = {
    --   [[                __                ]],
    --   [[  ___   __  __ /\_\    ___ ___    ]],
    --   [[ / _ `\/\ \/\ \\/\ \  / __` __`\  ]],
    --   [[/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    --   [[\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
    --   [[ \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
    -- },
    --
    -- this is: Slant Relief
    -- val = {
    --   [[___________________________________________________________________        ]],
    --   [[ ____________________________________/\\\___________________________       ]],
    --   [[  ________/\\/\\\\\\____/\\\____/\\\_\///_____/\\\\\__/\\\\\_________      ]],
    --   [[   _______\/\\\////\\\__\//\\\__/\\\___/\\\__/\\\///\\\\\///\\\_______     ]],
    --   [[    _______\/\\\__\//\\\__\//\\\/\\\___\/\\\_\/\\\_\//\\\__\/\\\_______    ]],
    --   [[     _______\/\\\___\/\\\___\//\\\\\____\/\\\_\/\\\__\/\\\__\/\\\_______   ]],
    --   [[      _______\/\\\___\/\\\____\//\\\_____\/\\\_\/\\\__\/\\\__\/\\\_______  ]],
    --   [[       _______\///____\///______\///______\///__\///___\///___\///________ ]],
    --   [[        ___________________________________________________________________]],
    -- },

    -- Get the current theme's background color
    local theme_bg = vim.api.nvim_get_hl_by_name('Normal', true).background
    -- Define the custom highlighting group dynamically
    vim.api.nvim_command(string.format('highlight CustomHeaderColor guifg=#98c379 guibg=%s', theme_bg))

    local header = {
      type = 'text',
      -- this is: Slant Relief
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

    local section_mru = {
      type = 'group',
      val = {
        {
          type = 'text',
          val = 'Recent files',
          opts = {
            hl = 'SpecialComment',
            shrink_margin = false,
            position = 'center',
          },
        },
        { type = 'padding', val = 1 },
        {
          type = 'group',
          val = function()
            return { mru(1, cdir, 4) }
          end,
          opts = { shrink_margin = false },
        },
      },
    }

    local buttons = {
      type = 'group',
      val = {
        { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
        { type = 'padding', val = 1 },
        dashboard.button('f', '  Find file', '<cmd>Telescope find_files<CR>'),
        dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('c', '  Configuration', '<cmd>cd $MYVIMRC<CR>'),
        dashboard.button('u', '  Update plugins', ':Lazy<CR>'),
        dashboard.button('q', '󰗼  Quit', ':qa<CR>'),
      },
      position = 'center',
    }

    -- Foot must be a table so that its height is correctly measured
    local stats = require('lazy').stats()
    local footer = {
      type = 'text',
      val = { '⚡ Neovim loaded ' .. stats.count .. ' plugins ' },
      opts = {
        position = 'center',
        hl = 'Comment',
      },
    }

    local opts = {
      layout = {
        { type = 'padding', val = 2 },
        header,
        { type = 'padding', val = 3 },
        greetHeading,
        footer,
        { type = 'padding', val = 2 },
        section_mru,
        { type = 'padding', val = 2 },
        buttons,
      },
      opts = {
        margin = 5,
      },
    }

    require('alpha').setup(opts)
  end,
}

return M


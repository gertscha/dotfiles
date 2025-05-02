return {
  -- blink completion
  "saghen/blink.cmp",
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      run = 'make install_jsregexp',
      config = function()
        local ls = require('luasnip')
        local paths = {}
        table.insert(paths, vim.fn.stdpath('config') .. '/lua/snippets')
        -- require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
        ls.config.setup({
          enable_autosnippets = true,
          update_events = { "TextChanged", "TextChangedI" },
          region_check_events = 'InsertEnter',
          delete_check_events = 'InsertLeave'
        })
      end
    },
  },
  event = 'InsertEnter',
  -- tag = 'v1.0.0',
  version = '1.*',
  opts = {
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
      per_filetype = {
        -- add lazydev to your completion providers (for lua only)
        lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
      },
      -- add lazydev as source (for require statements and module annotations)
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          max_items = 10,
          min_keyword_length = 2,
        },
        lsp = {
          max_items = 20,
          min_keyword_length = 2,
        },
        snippets = { max_items = 5, },
        path = {
          max_items = 3,
          min_keyword_length = 3,
          opts = {
            get_cwd = function(_) return vim.fn.getcwd() end,
          },
        },
        buffer = {
          max_items = 5,
          min_keyword_length = 3,
        },
      }, -- providers
    },   -- sources
    snippets = {
      preset = 'luasnip',
    },
    keymap = {
      preset = 'enter',
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<C-Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<Up>'] = {}, -- only allow C-p and C-n for navigation
      ['<Down>'] = {},
    },
    signature = {
      -- currently experimental
      enabled = true,
      window = {
        border = 'single',
        min_width = 10,
        max_width = 70,
        max_height = 20,
      },
    },
    completion = {
      keyword = { range = 'full' },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      ghost_text = { enabled = false, },
      list = {
        max_items = 100,
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      accept = {
        -- currently experimental, currently disabled (did not work when I tried)
        -- also covered by the delimitMate plugin
        auto_brackets = {
          enabled = false,
        }
      },
      menu = { border = 'none' },
      documentation = {
        window = { border = 'single' },
        auto_show = true,
        auto_show_delay_ms = 1000,
      },
    },
  },
  opts_extend = { "sources.default" },
}

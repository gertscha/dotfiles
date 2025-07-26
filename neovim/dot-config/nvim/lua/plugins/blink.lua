return {
  -- blink completion
  'saghen/blink.cmp',
  dependencies = {
    'echasnovski/mini.icons',
  },
  event = { 'InsertEnter', 'CmdlineEnter' },
  -- tag = 'v1.0.0',
  version = '1.*',
  opts = {
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
      per_filetype = {
        -- add lazydev to your completion providers (for lua only)
        lua = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      },
      -- add lazydev as source (for require statements and module annotations)
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 10,
          max_items = 10,
          min_keyword_length = 2,
        },
        lsp = {
          max_items = 20,
          min_keyword_length = 1,
          fallbacks = {}, -- this allows enables Buffer when LSP is active
        },
        snippets = {
          max_items = 8,
          min_keyword_length = 1,
          score_offset = 2,
        },
        path = {
          max_items = 8,
          min_keyword_length = 0,
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          max_items = 3,
          min_keyword_length = 2,
          score_offset = -3,
        },
      }, -- providers
    }, -- sources
    snippets = {
      preset = 'luasnip',
    },
    keymap = {
      preset = 'enter',
      -- preset keys:
      -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- ['<C-e>'] = { 'hide', 'fallback' },
      -- ['<CR>'] = { 'accept', 'fallback' },
      -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
      -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      -- ['<Up>'] = { 'select_prev', 'fallback' },
      -- ['<Down>'] = { 'select_next', 'fallback' },
      -- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      -- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      -- my changes/additions
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
      ['<Up>'] = {}, -- only allow C-p and C-n for navigation
      ['<Down>'] = {},
    },
    signature = {
      -- currently experimental
      enabled = false,
    },
    completion = {
      keyword = { range = 'full' },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      ghost_text = { enabled = false },
      list = {
        max_items = 100,
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      accept = {
        -- currently experimental, currently disabled (did not work when I tried)
        -- also covered by the autopairs plugin
        auto_brackets = {
          enabled = false,
        },
      },
      menu = {
        border = 'none',
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'source_name', gap = 2 },
          },
          components = {
            -- use icons and highlights from mini.icons
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            source_name = {
              text = function(ctx)
                local lbl = ctx.source_name
                if lbl == 'Snippets' then
                  return 'Snip'
                elseif lbl == 'LazyDev' then
                  return 'LDev'
                elseif lbl == 'Buffer' then
                  return 'Buf'
                else
                  return ctx.source_name
                end
              end,
            },
          }, -- components
        }, -- draw
      }, -- menu
    }, -- completion
  }, -- opts
  opts_extend = { 'sources.default' },
}

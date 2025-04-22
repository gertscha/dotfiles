return {
  -- blink completion
  "saghen/blink.cmp",
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  event = 'VeryLazy',
  -- tag = 'v1.0.0',
  version = '1.*',
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        -- add lazydev to your completion providers
        lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
      },
      -- add lazydev as source (for require statements and module annotations)
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 60, -- boost priority
        },
      },
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
        show_on_keyword = false,
      },
      ghost_text = { enabled = false, },
      list = {
        max_items = 300,
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

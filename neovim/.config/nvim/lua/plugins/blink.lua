return {
  -- blink completion
  "saghen/blink.cmp",
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  -- branch = 'release',
  tag = 'v0.13.1',
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
    },
    signature = {
      -- currently experimental
      enabled = true,
      window = {
        min_width = 10,
        max_width = 70,
        max_height = 20,
      },
    },
    completion = {
      ghost_text = { enabled = false, },
      list = {
        max_items = 300,
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      accept = {
        -- brackets currently handled by delimate
        -- since this is currently experimental I am disabling it for now
        auto_brackets = {
          enabled = false,
        }
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 1000,
      },
    },
  },
  opts_extend = { "sources.default" },
}

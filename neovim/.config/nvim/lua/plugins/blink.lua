return {
  -- blink completion
  "saghen/blink.cmp",
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  version = '0.9.2',
  opts = {
    sources = {
      -- add lazydev to your completion providers
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      -- add lazydev as source (for require statements and module annotations)
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
    keymap = {
      preset = 'enter',
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<C-Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
    completion = {
      ghost_text = { enabled = true, },
      list = {
        selection = 'auto_insert',
      },
      -- documentation = {
      --   auto_show = true,
      --   auto_show_delay_ms = 500,
      --   -- treesitter_highlighting = false, -- if there are performance issues
      -- },
    },
    snippets = {
      -- Function to use when expanding LSP provided snippets
      expand = function(snippet) vim.snippet.expand(snippet) end,
      -- Function to use when checking if a snippet is active
      active = function(filter) return vim.snippet.active(filter) end,
    },
  },
  opts_extend = { "sources.default" },
}

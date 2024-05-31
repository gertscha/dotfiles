-- better syntactic highlighting
local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-lua/plenary.nvim',
  },
  lazy = false,
  tag = 'v0.9.2',
}

function M.config()
  require('nvim-treesitter.configs').setup {
    TSConfig = {},
    modules = {},
    -- A list of parser names, or 'all' (the listed parsers should always be installed)
    ensure_installed = { 'markdown', 'latex', 'bash', 'rust', 'c', 'lua', 'vim', 'vimdoc' },
    ignore_install = { 'phpdoc' }, -- List of parsers to ignore installing
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    -- autopairs = { enable = true, },
    indent = {
      enable = true,
      disable = { 'python', 'css' }
    },
    incremental_selection = {
      enable = false,
      -- keymaps = {
      --   init_selection = 'gnn', -- set to `false` to disable one of the mappings
      --   node_incremental = 'grn',
      --   scope_incremental = 'grc',
      --   node_decremental = 'grm',
      -- },
    },
  }

  require('treesitter-context').setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 3, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  }

end

return M


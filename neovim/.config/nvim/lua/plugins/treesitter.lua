-- better syntactic highlighting
local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
  },
  enabled = false,
  lazy = true,
  event = { 'BufRead', 'BufNewFile' },
  tag = 'v0.9.3',
}

local function prequire(m)
  local ok, err = pcall(require, m)
  if not ok then return nil, err end
  return err
end

function M.config()
  require('nvim-treesitter.configs').setup {
    TSConfig = {},
    modules = {},
    -- A list of parser names, or 'all' (the listed parsers should always be installed)
    ensure_installed = { 'lua', 'markdown', 'latex', 'bash', 'rust', 'c', 'lua', 'vim', 'vimdoc' },
    ignore_install = { 'phpdoc' }, -- List of parsers to ignore installing
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 1000 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          print('Disabled treesitter due to large file size!')
          return true
        end
      end,
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

  local mod = prequire('treesitter-context')
  if mod then
    mod.setup {
      enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 6,           -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 50,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 3, -- Maximum number of lines to show for a single context
      trim_scope = 'outer',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',         -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20,     -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
  end
end

return M

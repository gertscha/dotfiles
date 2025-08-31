---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    -- master was archieved but is still default branch
    -- manually specifiy the 'main' branch, but is incompatible
    -- v0.10.0 works for neovim 0.10 to 0.12
    Add_plugin(spec, 'nvim-treesitter/nvim-treesitter', { version = 'v0.10.0' })
    Add_plugin(
      spec,
      'nvim-treesitter/nvim-treesitter-context',
      { version = 'v1.0.0' }
    )
  end,
}

function M.config()
  require('nvim-treesitter.configs').setup({
    TSConfig = {},
    modules = {},
    -- A list of parser names, or 'all' (the listed parsers should always be installed)
    ensure_installed = {
      'lua',
      'markdown',
      'latex',
      'bash',
      'rust',
      'vim',
      'vimdoc',
      'go',
      'html',
      'bibtex',
      'make',
      'cmake',
      'c',
      'cpp',
      'fish',
      'regex',
    },
    ignore_install = { 'phpdoc' }, -- List of parsers to ignore installing
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 1000 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          vim.notify(
            'Disabled treesitter due to large file size!',
            vim.log.levels.INFO
          )
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<Space><Enter>',
        node_incremental = '<Enter>',
        scope_incremental = false,
        node_decremental = '<BS>',
      },
    },
  })

  local mod = P_require('treesitter-context')
  if mod then
    mod.setup({
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 50, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 4, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    })
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup(
    'nvim-treesitter-pack-changed-update-handler',
    { clear = true }
  ),
  callback = function(event)
    if event.data.kind == 'update' then
      vim.notify('nvim-treesitter updated, running :TSUpdate', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if not ok then vim.notify('TSUpdate failed', vim.log.levels.WARN) end
    end
  end,
})

return M

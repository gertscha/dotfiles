---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(
      spec,
      'nvim-treesitter/nvim-treesitter',
      { version = 'main', enabled = true }
    )
    Add_plugin(
      spec,
      'sustech-data/wildfire.nvim',
      { version = 'master', enabled = true }
    )
    Add_plugin(
      spec,
      'nvim-treesitter/nvim-treesitter-context',
      -- disable to to performance issues (stutter on scroll over big context changes)
      { version = 'v1.0.0', enabled = true }
    )
  end,
}

function M.config()
  local mod_ts = P_require('nvim-treesitter', true)
  if mod_ts then
    mod_ts.install({
      'lua',
      'markdown',
      'latex',
      'bash',
      'rust',
      'yaml',
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
      'zig',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '*' },
      callback = function(args)
        local buf = args.buf
        -- Map the filetype to a treesitter language
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then return end
        -- Check if the parser is actually installed
        if not vim.treesitter.language.add(lang) then return end

        -- Do not enable it for big files
        local max_filesize = 1024 * 1024 -- 1MB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          vim.notify(
            'Disabled treesitter due to large file size!',
            vim.log.levels.INFO
          )
          return
        end

        vim.treesitter.start(buf, lang)

        -- start() disables regex highlights
        -- enable them again if the parser does not provided highlights
        local h_query = vim.treesitter.query.get(lang, 'highlights')
        if not h_query then vim.bo.syntax = 'ON' end

        -- enable the (experimental) treesitter indents if available
        local i_query = vim.treesitter.query.get(lang, 'indents')
        if i_query then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end

  -- wildfire does incremental selection
  -- (using this because treesitter dropped this capability)
  local mod_wf = P_require('wildfire', true)
  if mod_wf then
    require('wildfire').setup({
      surrounds = {
        { '(', ')' },
        { '{', '}' },
        { '<', '>' },
        { '[', ']' },
      },
      keymaps = {
        init_selection = '<leader><CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
      },
      filetype_exclude = { 'qf' },
    })
  end

  local mod_tsc = P_require('treesitter-context', true)
  if mod_tsc then
    mod_tsc.setup({
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

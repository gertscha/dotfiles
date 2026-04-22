---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    -- nvim-treesitter has been archieved, neovim itself is considering what
    -- to do, it will continue to work for a while but will break eventually
    Add_plugin(
      spec,
      'nvim-treesitter/nvim-treesitter',
      { version = '4916d6592ede8c07973490d9322f187e07dfefac', enabled = true }
    )
    Add_plugin(
      spec,
      'sustech-data/wildfire.nvim',
      { version = 'master', enabled = true }
    )
    Add_plugin(
      spec,
      'nvim-treesitter/nvim-treesitter-context',
      { version = 'v1.0.0', enabled = true }
    )
  end,
}

function M.config()
  -- To associate certain filetypes with a treesitter language (name of parser),
  -- use vim.treesitter.language.register()
  -- vim.treesitter.language.register('xml', { 'svg', 'xslt' })

  local augroup = vim.api.nvim_create_augroup('TreeSitterCheck', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = { '*' },
    callback = function(args)
      local bufnr = args.buf

      local is_running = vim.treesitter.highlighter.active[bufnr] ~= nil
      if is_running then return end

      local ft = vim.bo[bufnr].filetype
      if vim.bo[bufnr].buftype ~= '' then return end
      if ft == '' then
        vim.notify(
          'No filetype detected for current buffer',
          vim.log.levels.INFO,
          { title = 'treesitter' }
        )
        return
      end

      local lang = vim.treesitter.language.get_lang(ft) or ft
      local is_available = vim.treesitter.language.add(lang)
      if is_available then
        local ok, err = pcall(vim.treesitter.start, bufnr, lang)
        if not ok then
          vim.notify(
            string.format("Failed to start parser for '%s': %s", lang, err),
            vim.log.levels.ERROR,
            { title = 'treesitter' }
          )
        end
        -- start() disables regex highlights
        -- enable them again if the parser does not provided highlights
        local h_query = vim.treesitter.query.get(lang, 'highlights')
        if not h_query then vim.bo.syntax = 'ON' end
      end
    end,
  })

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

return M

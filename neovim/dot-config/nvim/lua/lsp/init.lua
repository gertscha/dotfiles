---@return { spec: function, config: function }

-- LSP setup
local M = {
  spec = function(spec)
    Add_plugin(spec, 'mason-org/mason.nvim', { version = 'v2.0.1' })
    Add_plugin(spec, 'stevearc/conform.nvim', { version = 'v9.0.0' })
    Add_plugin(spec, 'saghen/blink.cmp', { version = 'v1.6.0' })
    Add_plugin(spec, 'mfussenegger/nvim-lint', nil)
  end,
}

function M.config()
  vim.lsp.log.set_level(vim.lsp.log.levels.WARN)

  require('mason').setup({
    ui = {
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '󰅖',
      },
    },
  })

  -- Set filetype for some extensions manually
  vim.filetype.add({
    extension = {
      vert = 'glsl',
      frag = 'glsl',
      typ = 'typst',
    },
  })

  -- diagnostics settings
  vim.diagnostic.config({
    underline = true,
    virtual_lines = { current_line = true },
    update_in_insert = true,
    severity_sort = true,
    Float = {
      source = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '󰌶',
        [vim.diagnostic.severity.INFO] = '',
      },
      -- Highlight the line number
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
        [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      },
      -- Highlight entire line
      -- linehl = {
      --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      -- },
    },
  })

  -- enable a server
  vim.lsp.enable({ 'lua_ls', 'clangd', 'pyright', 'tinymist', 'texlab', 'gopls' })

  -- make it easy to enable a server on the fly
  vim.keymap.set('n', '<leader>de', function()
    local val = vim.fn.input('Server: ')
    if val ~= '' then
      vim.notify(string.format('Enabling LSP server: %s', val), vim.log.levels.INFO)
      vim.lsp.enable(val)
    end
  end, { noremap = true, desc = '[D]iagnostics [E]enable LSP server' })

  -- configure servers (in addition to lsp/ in the root dir)
  vim.lsp.config('*', {
    root_markers = { '.git', '.editorconfig' },
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
      },
    },
  })

  require('lsp.blink')
  require('lsp.on_attach')
  --
  -- Keybinds
  --

  -- Formatting
  require('lsp.conform')
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('my-format', { clear = true }),
    callback = function(args)
      local conf_format = P_require('conform')
      if conf_format then
        local fmtconvcnt = #conf_format.list_formatters(args.buf)
        if fmtconvcnt > 0 then
          vim.keymap.set({ 'n', 'v' }, '<leader>df', function()
            require('conform').format({ bufnr = args.buf })
          end, {
            noremap = true,
            silent = true,
            desc = '[D]iagnostics [F]ormat Buffer',
          })
        else
          vim.keymap.set({ 'n', 'v' }, '<leader>df', function()
            vim.notify('No Formatter available!', vim.log.levels.INFO)
          end, {
            noremap = true,
            silent = true,
            desc = '[D]iagnostics [F]ormat Buffer',
          })
        end
      end
    end,
  })

  -- Linting
  require('which-key').add({
    mode = 'n', -- NORMAL mode
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    {
      '<leader>dl',
      function()
        require('lsp.lint')
        require('lint').try_lint()
      end,
      desc = '[D]iagnostics [L]int Buffer',
    },
    {
      '<leader>dL',
      function()
        require('lsp.lint')
        require('lint').try_lint('cspell')
      end,
      desc = '[D]iagnostics [L]int Spellcheck',
    },
    {
      '<leader>drl',
      function()
        require('lsp.lint')
        vim.diagnostic.reset(
          require('lint').get_namespace('cspell'),
          vim.api.nvim_get_current_buf()
        )
      end,
      desc = 'LSP: Reset Spellcheck Linter',
    },
  })

  --
  -- user commands to make management easier
  --
  vim.api.nvim_create_user_command(
    'LspInfo',
    ':checkhealth vim.lsp',
    { desc = 'Alias to `:checkhealth vim.lsp`' }
  )

  vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
  end, { desc = 'Opens the Nvim LSP client log.' })

  vim.api.nvim_create_user_command('LspRestart', function(info)
    local clients = info.fargs
    -- Default to restarting all active servers
    if #clients == 0 then
      clients = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end
    for _, name in ipairs(clients) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
      end
    end
    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for _, name in ipairs(clients) do
        vim.schedule_wrap(function(x)
          vim.lsp.enable(x)
        end)(name)
      end
    end)
  end, {
    desc = 'Restart the given client',
    nargs = '?',
  })

  vim.api.nvim_create_user_command('LspStart', function(info)
    local clients = info.fargs
    -- Default to starting all active servers
    for _, name in ipairs(clients) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name)
      end
    end
  end, {
    desc = 'Start the given client',
    nargs = '+',
  })
  -- add a binding to restart the server
  vim.keymap.set('n', '<leader>drs', function()
    vim.cmd('LspRestart')
  end, { noremap = true, desc = 'Restart LSP server(s)' })

  vim.api.nvim_create_user_command('LspStop', function(info)
    local clients = info.fargs
    -- Default to stopping all active servers
    if #clients == 0 then
      clients = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end
    for _, name in ipairs(clients) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
      end
    end
  end, {
    desc = 'Stop the given client',
    nargs = '?',
  })
end

return M

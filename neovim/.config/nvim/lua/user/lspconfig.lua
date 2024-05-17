-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- enable LSP
  dependencies = {
    'folke/neodev.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'nvim-telescope/telescope.nvim',
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    -- 'simrat39/rust-tools.nvim',
    -- Autoformatting
    -- 'stevearc/conform.nvim',
    'folke/which-key.nvim',
  },
}

function M.config()
  -- diagnostic style options
  local icons = require('settings.icons')
  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
        { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
        { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
        { name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }
  vim.diagnostic.config(default_diagnostic_config)

  -- setup the icons properly
  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), 'signs', 'values') or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require('neodev').setup {
    -- library = {
    --   plugins = { 'nvim-dap-ui' },
    --   types = true,
    -- },
  }

  local capabilities = nil
  if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  end

  local lspconfig = require 'lspconfig'


  -- Add other tools here that you want Mason to install to
  -- the file lsp_server_config.lua
  local servers = require('user.configuration.lsp_server_settings')


  local servers_to_install = vim.tbl_filter(function(key)
    local t = servers[key]
    if type(t) == 'table' then
      return not t.manual_install
    else
      return t
    end
  end, vim.tbl_keys(servers))

  require('mason').setup({
    ui = {
      icons = {
        package_installed = icons.ui.Check,
        package_pending = icons.ui.CloudDownload,
        package_uninstalled = icons.ui.Close,
      }
    }
  })
  local ensure_installed = {
    -- LSP's
    'stylua',
    'lua_ls',
    -- 'asm-lsp',
    -- 'cmake-language-server',
    -- 'golangci-lint-langserver',
    -- 'html-lsp',
    -- 'htmx-lsp',
    -- 'java-language-server',
    -- 'jq-lsp',
    -- 'json-lsp',
    -- 'markdown-oxide',
    -- 'marksman',
    -- 'ocaml-lsp',
    -- 'pyright',
    -- 'python-lsp-server',
    -- 'zls',

    -- DAP's
    'cpptools',
    -- 'codelldb',
    -- 'go-debug-adapter',
    -- 'debugpy',
    -- 'java-debug-adapter,
    -- 'java-language-server,
    -- 'ocamlearlybird,

    -- Formatters

    -- Linters
  }

  vim.list_extend(ensure_installed, servers_to_install)
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, config in pairs(servers) do
    if config == true then
      config = {}
    end
    config = vim.tbl_deep_extend('force', {}, {
      capabilities = capabilities,
    }, config)

    lspconfig[name].setup(config)
  end


  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')

      vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

      local kopts = {
        mode = 'n', -- NORMAL mode
        prefix = '', -- the prefix is prepended to every mapping part of `mappings`
        buffer = bufnr, -- nil for Global mappings. Give buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = false, -- use `nowait` when creating keymaps
        expr = false, -- use `expr` when creating keymaps
      }
      require('which-key').register({
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        ['K'] = { vim.lsp.buf.hover, 'LSP: Lookup Symbol' },
        ['g'] = {
          r = { vim.lsp.buf.references, 'LSP: [r]eferences' },
          T = { vim.lsp.buf.type_definition, 'LSP: [g]et [t]ype definition' },
          D = { vim.lsp.buf.declaration, 'LSP: [g]o to [D]eclaration' },
          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-T>.
          d = { vim.lsp.buf.definition, 'LSP: [g]o to [d]efinition' },
        },
        ['<leader>'] = {
          d = {
            name = 'diagnostics',
            r = { vim.lsp.buf.rename, 'LSP: [r]ename symbol under the cursor' },
            -- Execute a code action, usually your cursor needs to be on top of an error
            a = { vim.lsp.buf.code_action, 'LSP: code [a]ctions' },
            f = { vim.diagnostic.open_float, 'LSP: View [d]iagnostic [f]loat' },
            w = { vim.lsp.buf.workspace_symbol, 'LSP: Query [w]orkspace symbols' },
            i = { require('telescope.builtin').lsp_implementations, 'LSP: [i]mplementation' },
            s = { '<cmd>Telescope diagnostics<cr>', 'LSP: [d]iagnostics [s]earch' },
          },
        },
      }, kopts)

      -- -- Diagnostic keymaps
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
      -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })


      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local clienthl = vim.lsp.get_client_by_id(args.data.client_id)
      if clienthl and clienthl.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = args.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = args.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

end

return M


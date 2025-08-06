-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- contains LSP server info
  dependencies = {
    -- make Lua aware of neovim api
    'folke/lazydev.nvim', -- make sure it is loaded first
    -- installing and configure LSP servers
    {
      'mason-org/mason-lspconfig.nvim',
      dependencies = {
        'mason-org/mason.nvim',
      },
    },
    -- auto complete and snippets
    'saghen/blink.cmp',
    -- 'L3MON4D3/LuaSnip', -- loaded on 'InsertEnter'
    -- Autoformatting
    'stevearc/conform.nvim',
    -- Linting
    'mfussenegger/nvim-lint',
    -- other integrations
    'folke/which-key.nvim',
    -- 'simrat39/rust-tools.nvim',
  },
  cmd = 'LspInfo',
  event = { 'User my.lazy.trigger', 'InsertEnter' },
}

local function lspKeybind(buf, key, fun, mode, desc)
  local wk = require('which-key')
  wk.add({
    mode = mode,
    buffer = buf,
    silent = true,
    { key, fun, desc = desc },
  })
end

function M.config()
  vim.lsp.set_log_level('off')

  local icons = require('settings.icons')
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
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
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

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
      },
    },
  })

  -- mason-lspconfig automates the lsp server setup for mason installed servers
  -- servers not installed with Mason need to be enabled manually
  require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'texlab', 'clangd', 'pyright' },
    automatic_enable = true,
  })

  -- manually enable a server
  -- vim.lsp.enable('lua_ls')

  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- nil check, should not happen
      if not client then
        vim.notify('LSP client should not be nil', vim.log.levels.ERROR)
        return
      end

      -- enable snacks.indent, otherwise an error popup if entering file with
      -- harpoon that does not have clear scopes, so we require a LSP for first
      -- enable, or do it manually with the key bind (a bug, on dfe44a6, v0.11.2)
      local snacks_indent = require('snacks.indent')
      snacks_indent.enable()

      -- formatting
      local conf_format = P_require('conform')
      local format_fun = nil
      local lsp_format = client:supports_method(
        vim.lsp.protocol.Methods.textDocument_formatting,
        args.buf
      )
      if lsp_format and not conf_format then
        format_fun = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end
      elseif conf_format then
        local fmtlspcnt = (lsp_format ~= false and 1 or 0)
        local fmtconvcnt = #conf_format.list_formatters(args.buf)
        if fmtconvcnt + fmtlspcnt > 0 then
          format_fun = function()
            conf_format.format({ bufnr = args.buf, lsp_format = 'fallback' })
          end
        else
          format_fun = function()
            vim.notify(
              'No Formatter available for this buffer!',
              vim.log.levels.INFO
            )
          end
        end
      else
        format_fun = function()
          vim.notify('LSP does not support formatting!', vim.log.levels.INFO)
        end
      end
      -- do the format mapping
      lspKeybind(
        args.buf,
        '<leader>df',
        format_fun,
        { 'n', 'v' },
        '[D]iagnostics [F]ormat Buffer'
      )

      -- add a binding to restart the server
      lspKeybind(nil, '<leader>drs', function()
        vim.cmd('LspRestart')
      end, { 'n' }, 'LSP: Restart LSP server(s)')

      --
      -- LSP methods/capabilities, only add keybind if the server can do it
      --

      -- blink.cmp takes care of this
      -- if client:supports_method(
      --     vim.lsp.protocol.Methods.textDocument_completion, args.buf)
      -- then
      --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end

      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_implementation,
          args.buf
        )
      then
        lspKeybind(
          args.buf,
          'gI',
          vim.lsp.buf.implementation,
          'n',
          'LSP: [g]o to [I]implementation'
        )
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_rename,
          args.buf
        )
      then
        lspKeybind(args.buf, 'grn', vim.lsp.buf.rename, 'n', 'LSP: re[n]ame symbol')
      end
      if
        client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, args.buf)
      then
        lspKeybind(args.buf, 'K', vim.lsp.buf.hover, 'n', 'LSP: Lookup Symbol')
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_declaration,
          args.buf
        )
      then
        lspKeybind(
          args.buf,
          'gD',
          vim.lsp.buf.declaration,
          'n',
          'LSP: [g]o to [D]eclaration'
        )
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_definition,
          args.buf
        )
      then
        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-T>.
        lspKeybind(
          args.buf,
          'gd',
          vim.lsp.buf.definition,
          'n',
          'LSP: [g]o to [d]efinition'
        )
      end

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_documentHighlight,
          args.buf
        )
      then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = args.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        -- When the cursor is moved, clear the highlights
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = args.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end

      local fzflua = P_require('fzf-lua')
      if fzflua then
        if
          client:supports_method(
            vim.lsp.protocol.Methods.textDocument_references,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            'grr',
            fzflua.lsp_references,
            'n',
            'LSP: get [r]eferences'
          )
        end
        if
          client:supports_method(
            vim.lsp.protocol.Methods.textDocument_typeDefinition,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            'grt',
            fzflua.lsp_typedefs,
            'n',
            'LSP: get [t]ype definition'
          )
        end
        if
          client:supports_method(
            vim.lsp.protocol.Methods.textDocument_codeAction,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            'gra',
            fzflua.lsp_code_actions,
            'n',
            'LSP: code [a]ctions'
          )
        end
        if
          client:supports_method(
            vim.lsp.protocol.Methods.textDocument_documentSymbol,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            'grs',
            fzflua.lsp_document_symbols,
            'n',
            'LSP: get [s]ymbols in document'
          )
        end
        if
          client:supports_method(vim.lsp.protocol.Methods.workspace_symbol, args.buf)
        then
          lspKeybind(
            args.buf,
            'grS',
            fzflua.lsp_workspace_symbols,
            'n',
            'LSP: get [S]ymbols in workspace'
          )
        end
        lspKeybind(
          args.buf,
          '<leader>sd',
          fzflua.lsp_finder,
          'n',
          '[S]earch [d]iagnostics for symbol under cursor'
        )
        if
          client:supports_method(
            vim.lsp.protocol.Methods.callHierarchy_incomingCalls,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            '<leader>dci',
            fzflua.lsp_incoming_calls,
            'n',
            'LSP: [i]ncoming calls'
          )
        end
        if
          client:supports_method(
            vim.lsp.protocol.Methods.callHierarchy_outgoingCalls,
            args.buf
          )
        then
          lspKeybind(
            args.buf,
            '<leader>dco',
            fzflua.lsp_outgoing_calls,
            'n',
            'LSP: [o]utgoing calls'
          )
        end
        lspKeybind(
          args.buf,
          'grm',
          fzflua.diagnostics_document,
          'n',
          'LSP: diagnostics [m]essages in buffer'
        )
        lspKeybind(
          args.buf,
          'grM',
          fzflua.diagnostics_workspace,
          'n',
          'LSP: diagnostics [M]essages in workspace'
        )
      end
    end,
  })
end

return M

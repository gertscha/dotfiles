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
    -- other integrations
    'folke/which-key.nvim',
    -- 'simrat39/rust-tools.nvim',
  },
  cmd = 'LspInfo',
  event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
}

local function lspKeybind(buf, key, fun, desc)
  local wk = require('which-key')
  wk.add({
    mode = 'n',
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
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      },
      -- Highlight entire line
      -- linehl = {
      --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      -- },
    },
  })

  -- mason-lspconfig automates the lsp server setup for mason insalled servers
  -- servers not installed with Mason need to be enabled manually
  require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls' },
    automatic_enable = true,
  })

  -- manually enable a server
  -- vim.lsp.enable('lua_ls')

  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- nil check, should not happen
      if not client then
        vim.notify('LSP client should not be nil', vim.log.ERROR)
        return
      end

      -- formatting
      local conf_format = P_require('conform')
      local format_fun = nil
      local lsp_format = client:supports_method('textDocument/formatting')
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
            vim.notify('No Formatter available for this buffer!', vim.log.INFO)
          end
        end
      else
        format_fun = function()
          vim.notify('LSP does not support formatting!', vim.log.INFO)
        end
      end
      -- do the format mapping
      lspKeybind(args.buf, '<leader>df', format_fun, '[D]iagnostics [F]ormat Buffer')

      --
      -- LSP methods/capabilites, only add keybind if the server can do it
      --

      -- blink.cmp takes care of this
      -- if client:supports_method('textDocument/completion') then
      --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end
      if client:supports_method('textDocument/implementation') then
        lspKeybind(
          args.buf,
          'gI',
          vim.lsp.buf.implementation,
          'LSP: [g]o to [I]implementation'
        )
      end
      if client:supports_method('textDocument/rename') then
        lspKeybind(
          args.buf,
          '<leader>dr',
          vim.lsp.buf.rename,
          'LSP: [r]ename symbol'
        )
      end
      if client:supports_method('textDocument/hover') then
        lspKeybind(args.buf, 'K', vim.lsp.buf.hover, 'LSP: Lookup Symbol')
      end
      if client:supports_method('textDocument/declaration') then
        lspKeybind(
          args.buf,
          'gD',
          vim.lsp.buf.declaration,
          'LSP: [g]o to [D]eclaration'
        )
      end
      if client:supports_method('textDocument/definition') then
        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-T>.
        lspKeybind(
          args.buf,
          'gd',
          vim.lsp.buf.definition,
          'LSP: [g]o to [d]efinition'
        )
      end

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      if client:supports_method('documentHighlightProvider') then
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
        if client:supports_method('textDocument/references') then
          lspKeybind(
            args.buf,
            'gr',
            fzflua.lsp_references,
            'LSP: [g]et [r]eferences'
          )
        end
        if client:supports_method('textDocument/typeDefinition') then
          lspKeybind(
            args.buf,
            'gT',
            fzflua.lsp_typedefs,
            'LSP: [g]et [t]ype definition'
          )
        end
        if client:supports_method('textDocument/codeAction') then
          lspKeybind(
            args.buf,
            '<leader>da',
            fzflua.lsp_code_actions,
            'LSP: code [a]ctions'
          )
        end
        if client:supports_method('textDocument/documentSymbol') then
          lspKeybind(
            args.buf,
            '<leader>ds',
            fzflua.lsp_document_symbols,
            'LSP: [S]ymbols in document'
          )
        end
        if client:supports_method('workspace/symbol') then
          lspKeybind(
            args.buf,
            '<leader>dS',
            fzflua.lsp_workspace_symbols,
            'LSP: Query [S]ymbols in workspace'
          )
        end
        lspKeybind(
          args.buf,
          '<leader>sl',
          fzflua.lsp_finder,
          '[S] LSP for symbol under cursor'
        )
        lspKeybind(
          args.buf,
          '<leader>dci',
          fzflua.lsp_incoming_calls,
          'LSP: [i]ncoming calls'
        )
        lspKeybind(
          args.buf,
          '<leader>dco',
          fzflua.lsp_outgoing_calls,
          'LSP: [o]utgoing calls'
        )
        lspKeybind(
          args.buf,
          '<leader>sd',
          fzflua.diagnostics_document,
          '[S]earch [d]iagnostics in current buffer'
        )
        lspKeybind(
          args.buf,
          '<leader>sD',
          fzflua.diagnostics_workspace,
          '[S]earch [D]iagnostics in workspace'
        )
      end
    end,
  })
end

return M

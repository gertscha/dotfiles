-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- contains LSP server info
  dependencies = {
    -- make Lua aware of neovim api
    'folke/lazydev.nvim', -- make sure it is loaded first
    -- installing and configure LSP servers
    'mason-org/mason-lspconfig.nvim',
    -- auto complete and snippets
    'saghen/blink.cmp',
    'L3MON4D3/LuaSnip',
    -- Autoformatting
    'stevearc/conform.nvim',
    -- other integrations
    'j-hui/fidget.nvim', -- status info
    'folke/which-key.nvim',
    -- 'simrat39/rust-tools.nvim',
  },
  event = { 'BufRead', 'BufNewFile' },
}

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

  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local wk = require('which-key')
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- nil check, should not happen
      if not client then
          vim.notify("LSP client should not be nil", vim.log.ERROR)
        return
      end

      -- formatting
      local conf_format = P_require('conform')
      local format_fun = nil
      local lsp_format = client:supports_method('textDocument/formatting')
      if lsp_format and not conf_format then
        format_fun =
            function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end
      elseif conf_format then
        local fmtlspcnt = (lsp_format ~= false and 1 or 0)
        local fmtconvcnt = #conf_format.list_formatters(args.buf)
        if fmtconvcnt + fmtlspcnt > 0 then
          format_fun = function()
            conf_format.format({ bufnr = args.buf, lsp_format = 'fallback' })
          end
        else
          format_fun = function()
            vim.notify("No Formatter available for this buffer!", vim.log.INFO)
          end
        end
      else
        format_fun = function()
          vim.notify("LSP does not support formatting!", vim.log.INFO)
        end
      end

      wk.add({
        buffer = args.buf,
        { '<leader>df', format_fun, desc = '[D]iagnostics [F]ormat Buffer', },
      })

      -- if client:supports_method('textDocument/completion') then
      --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end
      if client:supports_method('textDocument/implementation') then
        wk.add({
          buffer = args.buf,
          { 'gI', vim.lsp.buf.implementation, desc = 'LSP: [g]o to [I]implementation' },
        })
      end
      if client:supports_method('textDocument/rename') then
        wk.add({
          buffer = args.buf,
          { '<leader>dr', vim.lsp.buf.rename, desc = 'LSP: [r]ename symbol under the cursor' },
        })
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

      local tb = require('telescope.builtin')
      wk.add({
        mode = 'n',        -- NORMAL mode
        buffer = args.buf, -- nil for Global mappings. Give buffer number for buffer local mappings
        silent = true,     -- use `silent` when creating keymaps
        noremap = true,    -- use `noremap` when creating keymaps
        nowait = false,    -- use `nowait` when creating keymaps
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        { 'K',          vim.lsp.buf.hover,            desc = 'LSP: Lookup Symbol', },
        { 'gr',         tb.lsp_references,            desc = 'LSP: [r]eferences', },
        { 'gT',         vim.lsp.buf.type_definition,  desc = 'LSP: [g]et [t]ype definition', },
        { 'gD',         vim.lsp.buf.declaration,      desc = 'LSP: [g]o to [D]eclaration', },
        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-T>.
        { 'gd',         vim.lsp.buf.definition,       desc = 'LSP: [g]o to [d]efinition', },
        { '<leader>d',  group = 'diagnostics' },
        -- Execute a code action, usually your cursor needs to be on top of an error
        { '<leader>da', vim.lsp.buf.code_action,      desc = 'LSP: code [a]ctions', },
        -- { '<leader>dk', vim.diagnostic.open_float,                desc = 'LSP: View [d]iagnostic float' },
        { '<leader>dw', vim.lsp.buf.workspace_symbol, desc = 'LSP: Query [w]orkspace symbols', },
        { '<leader>ds', tb.diagnostics,               desc = 'LSP: [d]iagnostics [s]earch', },
      })
    end,
  })
end

return M

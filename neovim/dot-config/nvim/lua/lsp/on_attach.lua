--
-- The autocommand to configure LSP stuff when the server attaches to the buffer
--
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- nil check, should not happen
    if not client then
      vim.notify('LSP client should not be nil', vim.log.levels.ERROR)
      return
    end

    -- vim.notify('Attached LSP Server', vim.log.levels.INFO, {
    --   id = 'lsp_progress',
    --   title = client.name,
    -- })

    local function lspKeybind(mode, key, fun, buf, desc)
      vim.keymap.set(mode, key, fun, { buffer = buf, desc = desc, noremap = true })
    end

    -- enable snacks.indent, otherwise an error popup if entering file with
    -- harpoon that does not have clear scopes, so we require a LSP for first
    -- enable, or do it manually with the key bind (a bug, on dfe44a6, v0.11.2)
    local snacks_indent = P_require('snacks.indent')
    if snacks_indent then snacks_indent.enable() end

    -- formatting
    local format_fun = nil
    local conf_format = P_require('conform')
    local lsp_format = client:supports_method(
      vim.lsp.protocol.Methods.textDocument_formatting,
      args.buf
    )
    if lsp_format then
      format_fun = function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      end
    end
    if conf_format then
      local fmtconvcnt = #conf_format.list_formatters(args.buf)
      if fmtconvcnt > 0 then
        format_fun = function()
          conf_format.format({ bufnr = args.buf, lsp_format = 'fallback' })
        end
      end
    end
    -- tinymist does not advertise formatting correctly
    if client.name == 'tinymist' then
      format_fun = function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      end
    end
    if format_fun == nil then
      format_fun = function()
        vim.notify('No Formatter available for this buffer!', vim.log.levels.INFO)
      end
    end
    -- do the format mapping
    vim.keymap.set(
      { 'n', 'v' },
      '<leader>df',
      format_fun,
      { buffer = args.buf, noremap = true, desc = '[D]iagnostics [F]ormat Buffer' }
    )

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
      client:supports_method(vim.lsp.protocol.Methods.textDocument_rename, args.buf)
    then
      lspKeybind('n', 'grn', vim.lsp.buf.rename, args.buf, 'LSP: re[n]ame symbol')
    end
    if
      client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, args.buf)
    then
      lspKeybind('n', 'K', vim.lsp.buf.hover, args.buf, 'LSP: Lookup Symbol')
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

    -- if fzflua is not available, there are fallback keybinds to the default
    -- nvim functions behind <leader>d, defined in lua/settings/keybinds.lua
    local fzflua = P_require('fzf-lua')
    if fzflua then
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_definition,
          args.buf
        )
      then
        -- Jump to the definition of the word under your cursor.
        -- To jump back, press <C-T>.
        lspKeybind(
          'n',
          'gd',
          fzflua.lsp_definitions,
          args.buf,
          'LSP: [g]o to [d]efinition'
        )
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_declaration,
          args.buf
        )
      then
        lspKeybind(
          'n',
          'gD',
          fzflua.lsp_declarations,
          args.buf,
          'LSP: [g]o to [D]eclaration'
        )
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_implementation,
          args.buf
        )
      then
        lspKeybind(
          'n',
          'gri',
          fzflua.lsp_implementations,
          args.buf,
          'LSP: [g]o to [I]implementation'
        )
      end
      if
        client:supports_method(
          vim.lsp.protocol.Methods.textDocument_references,
          args.buf
        )
      then
        lspKeybind(
          'n',
          'grr',
          fzflua.lsp_references,
          args.buf,
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
          'n',
          'grt',
          fzflua.lsp_typedefs,
          args.buf,
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
          'n',
          'gra',
          fzflua.lsp_code_actions,
          args.buf,
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
          'n',
          'grs',
          fzflua.lsp_document_symbols,
          args.buf,
          'LSP: get [s]ymbols in document'
        )
      end
      if
        client:supports_method(vim.lsp.protocol.Methods.workspace_symbol, args.buf)
      then
        lspKeybind(
          'n',
          'grS',
          fzflua.lsp_workspace_symbols,
          args.buf,
          'LSP: get [S]ymbols in workspace'
        )
      end
      lspKeybind(
        'n',
        '<leader>sd',
        fzflua.lsp_finder,
        args.buf,
        '[S]earch [d]iagnostics for symbol under cursor'
      )
      if
        client:supports_method(
          vim.lsp.protocol.Methods.callHierarchy_incomingCalls,
          args.buf
        )
      then
        lspKeybind(
          'n',
          '<leader>dci',
          fzflua.lsp_incoming_calls,
          args.buf,
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
          'n',
          '<leader>dco',
          fzflua.lsp_outgoing_calls,
          args.buf,
          'LSP: [o]utgoing calls'
        )
      end
    end
  end,
})

-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- contains LSP server info
  dependencies = {
    -- setup relevant
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'folke/lazydev.nvim', -- make sure it is loaded first
    -- other integrations
    'saghen/blink.cmp',   -- completion
    'j-hui/fidget.nvim',  -- status info
    'folke/which-key.nvim',
    -- 'simrat39/rust-tools.nvim',
    -- Autoformatting
    -- 'stevearc/conform.nvim',
  },
  event = { 'BufRead', 'BufNewFile' },
}

function M.config()
  -- base diagnostics settings
  vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    severity_sort = true,
  })
  -- customize the gutter signs from character to icons
  -- see: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
  local icons = require('settings.icons')
  local signs = {
    Error = icons.diagnostics.Error,
    Warn = icons.diagnostics.Warning,
    Hint = icons.diagnostics.Hint,
    Info = icons.diagnostics.Information,
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  -- mason setup (installs lsp servers) and ui customization
  require('mason').setup({
    ui = {
      icons = {
        package_installed = icons.ui.Check,
        package_pending = icons.ui.CloudDownload,
        package_uninstalled = icons.ui.Close,
      }
    }
  })
  -- mason-lspconfig automates the lsp server setup for mason insalled servers
  require("mason-lspconfig").setup({
    automatic_installation = false,
    ensure_installed = { 'lua_ls' },
  })
  -- this does the server setup automatically
  -- read the help: mason-lspconfig.setup_handlers()
  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler. We will always use this one, and check for dedicated
    -- configuration inside of it
    -- Dedicated servers are configured in 'configuration/lsp_servers.lua'
    function(server_name)
      -- want to run stuff like this:
      -- require('lspconfig').lua_ls.setup {}
      -- but also supply the settings given in lsp_servers.lua
      -- we also add the completion capabilites from the blink plugin
      local my_servers = require('plugins.configuration.lsp_servers')
      local blink_getlspcap = require('blink.cmp').get_lsp_capabilities

      -- check if we have a config for the server
      if my_servers.server_name ~= nil then
        -- load the config
        local config = my_servers[server_name]
        if config == true then -- the server is just set as true
          config = {}
        end
        if config.capabilites == nil then
          config.capabilites = {}
        end
        config.capabilites = blink_getlspcap(config.capabilites)
        require('lspconfig')[server_name].setup(config)
      else
        -- have no config, just give the empty one
        local capabilities = blink_getlspcap()
        require("lspconfig")[server_name].setup({ capabilites = capabilities })
      end
    end,
  }

  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local wk = require('which-key')
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      -- formatting based settings
      if client.supports_method('textDocument/formatting', nil) then
        if client.name ~= "texlab" then
          -- Format current buffer on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end,
          })
          -- wk.add({
          --   buffer = args.buf,
          --   {
          --     '<leader>dbf',
          --     vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = true }),
          --     desc = 'LSP: [B]uffer [F]ormat'
          --   },
          -- })
        end
      end
      if client.supports_method('textDocument/implementation') then
        wk.add({
          buffer = args.buf,
          { 'gI', vim.lsp.buf.implementation, desc = 'LSP: [g]o to [I]implementation' },
        })
      end
      if client.supports_method('textDocument/rename') then
        wk.add({
          buffer = args.buf,
          { '<leader>dr', vim.lsp.buf.rename, desc = 'LSP: [r]ename symbol under the cursor' },
        })
      end
      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      if client.supports_method('documentHighlightProvider', nil) then
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
      -- if client.supports_method('textDocument/completion', nil) then
      -- vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end

      wk.add({
        mode = 'n',        -- NORMAL mode
        buffer = args.buf, -- nil for Global mappings. Give buffer number for buffer local mappings
        silent = true,     -- use `silent` when creating keymaps
        noremap = true,    -- use `noremap` when creating keymaps
        nowait = false,    -- use `nowait` when creating keymaps
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        { 'K',          vim.lsp.buf.hover,                           desc = 'LSP: Lookup Symbol' },
        { 'gr',         require('telescope.builtin').lsp_references, desc = 'LSP: [r]eferences' },
        { 'gT',         vim.lsp.buf.type_definition,                 desc = 'LSP: [g]et [t]ype definition' },
        { 'gD',         vim.lsp.buf.declaration,                     desc = 'LSP: [g]o to [D]eclaration' },
        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-T>.
        { 'gd',         vim.lsp.buf.definition,                      desc = 'LSP: [g]o to [d]efinition' },
        { '<leader>d',  group = 'diagnostics' },
        -- Execute a code action, usually your cursor needs to be on top of an error
        { '<leader>da', vim.lsp.buf.code_action,                     desc = 'LSP: code [a]ctions' },
        { '<leader>df', vim.diagnostic.open_float,                   desc = 'LSP: View [d]iagnostic [f]loat' },
        { '<leader>dw', vim.lsp.buf.workspace_symbol,                desc = 'LSP: Query [w]orkspace symbols' },
        { '<leader>ds', '<cmd>Telescope diagnostics<cr>',            desc = 'LSP: [d]iagnostics [s]earch' },
      })
    end,
  })
end

return M

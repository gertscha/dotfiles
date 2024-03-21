-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- enable LSP
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'folke/neodev.nvim', -- lsp for neovim config folder
      tag = "stable",
      opts = {}, -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    },
    {
      'j-hui/fidget.nvim', -- visualize lsp progress
      tag = 'v1.2.0',
      opts = {},
    },
    'folke/which-key.nvim',
    'nvim-telescope/telescope.nvim',
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    -- 'simrat39/rust-tools.nvim',
  },
}

function M.config()
  local icons = require("settings.icons")

  -- diagnostic style options
  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  -- setup the icons properly
  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end


  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
    callback = function(event)

      local kopts = {
        mode = "n", -- NORMAL mode
        prefix = "", -- the prefix is prepended to every mapping part of `mappings`
        buffer = event.buf, -- nil for Global mappings. Give buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = false, -- use `nowait` when creating keymaps
        expr = false, -- use `expr` when creating keymaps
      }
      -- -- Diagnostic keymaps
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
      -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
      -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

      require("which-key").register({
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        ["K"] = { vim.lsp.buf.hover, "LSP: Lookup Symbol" },
        ["g"] = {
          D = { vim.lsp.buf.declaration, "LSP: [g]o to [D]eclaration" },
          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-T>.
          d = { require('telescope.builtin').lsp_definitions, "LSP: [g]o to [d]efinition" },
        },
        ["<leader>"] = {
          d = {
            name = "diagnostics",
            f = { vim.diagnostic.open_float, "LSP: View [d]iagnostic [f]loat" },
            i = { require('telescope.builtin').lsp_implementations, "LSP: [i]mplementation" },
            r = { vim.lsp.buf.rename, "LSP: [r]ename symbol under the cursor" },
            -- Fuzzy find all the symbols in your current document.
            s = { require('telescope.builtin').lsp_document_symbols, "LSP: [d]ocument [s]ymbols" },
            d = {
              s = { "<cmd>Telescope diagnostics<cr>", 'LSP: [d]iagnostics [s]earch' },
              r = { require('telescope.builtin').lsp_references, "LSP: [r]eferences"},
              -- Jump to the type of the word under your cursor (Not where it was defined).
              t = { require('telescope.builtin').lsp_type_definitions, "LSP: [t]ype definition"},
              w = { vim.lsp.buf.workspace_symbol, "LSP: [w]orkspace symbols" },
              -- Execute a code action, usually your cursor needs to be on top of an error
              a = { vim.lsp.buf.code_action, "LSP: code [a]ctions" },
            },
            -- Fuzzy find all the symbols in your current workspace
            ws = { require('telescope.builtin').lsp_dynamic_workspace_symbols, "LSP: [w]orkspace [s]ymbols"},
          },
        },
      }, kopts)

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP Specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

  -- Add other tools here that you want Mason to install to
  -- the file lsp_server_config.lua
  local servers = require("user.lspsettings.lsp_server_config")

  require('mason').setup({
    PATH = "prepend", -- "skip" seems to cause the spawning error
    ui = {
      icons = {
        package_installed = icons.ui.Check,
        package_pending = icons.ui.CloudDownload,
        package_uninstalled = icons.ui.Close,
      }
    }
  })

  local ensure_installed = vim.tbl_keys(servers or {})

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    automatic_installation = true,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        require('lspconfig')[server_name].setup {
          cmd = server.cmd,
          settings = server.settings,
          filetypes = server.filetypes,
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
        }
      end,
    },
  }
end

return M


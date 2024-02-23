-- configure lsp servers
local M = {
  'neovim/nvim-lspconfig', -- enable LSP
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    -- 'simrat39/rust-tools.nvim',
    'folke/which-key.nvim',
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
  },
}

function M.on_attach(client, bufnr)
  local kopts = {
    mode = "n", -- NORMAL mode
    prefix = "", -- the prefix is prepended to every mapping part of `mappings`
    buffer = bufnr, -- nil for Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }
  require("which-key").register({
    ["K"] = { "vim.lsp.buf.hover", "LSP: Lookup Symbol" },
    ["g"] = {
      D = { vim.lsp.buf.declaration, "LSP: [g]o to [D]eclaration" },
      d = { vim.lsp.buf.definition, "LSP: [g]o to [d]efinition" },
    },
    ["<leader>"] = {
      d = {
        name = "diagnostics",
        f = { vim.diagnostic.open_float, "LSP: View [d]iagnostic [f]loat" },
        i = { vim.lsp.buf.implementation, "LSP: [i]mplementation" },
        r = { vim.lsp.buf.rename, "LSP: [r]ename symbol under the cursor" },
        d = {
          s = { "<cmd>Telescope diagnostics<cr>", 'LSP: [d]iagnostics [s]earch' },
          r = { vim.lsp.buf.references, "LSP: [r]eferences in quickfix window"},
          w = { vim.lsp.buf.workspace_symbol, "LSP: [w]orkspace symbols" },
          a = { vim.lsp.buf.code_action, "LSP: code [a]ctions" },
        },
      },
    },
  }, kopts)

  if client.supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.config()
  local lspconfig = require("lspconfig")
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

  -- setup the servers,
  for _, server in pairs(LSP_SERVERS) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    -- allow fine grained control over each server
    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    lspconfig[server].setup(opts)
  end

end

return M


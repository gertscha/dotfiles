local M = {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  run = 'make install_jsregexp',
  event = 'InsertEnter',
  depedencies = {
    'folke/which-key.nvim',
    'echasnovski/mini.icons', -- for the colors
  },
}

function M.config()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')

  -- setup snippet loading
  local paths = {}
  table.insert(paths, vim.fn.stdpath('config') .. '/lua/snippets')
  -- require("luasnip.loaders.from_vscode").lazy_load()
  require('luasnip.loaders.from_lua').lazy_load({ paths = paths })

  -- configure
  ls.config.setup({
    enable_autosnippets = false, -- currently I have no autosnippets, save performance
    keep_roots = true, -- make it possible to resume a snippet
    update_events = { 'TextChanged', 'TextChangedI' },
    delete_check_events = { 'TextChanged', 'InsertEnter' },
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '◀ Choice Node', 'Comment' } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { '◀ Insert Node', 'Comment' } },
        },
      },
    },
  })

  -- add keybinds
  local mod = P_require('which-key')
  if mod then
    mod.add({
      mode = { 'i', 's' },
      buffer = nil, -- nil for Global mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
      {
        '<C-s>',
        function()
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          else
            vim.lsp.buf.signature_help()
          end
        end,
        desc = 'If available: "Snippet expand or jump", else "LSP signature help"',
      },
      {
        '<C-n>',
        function()
          if ls.choice_active() then ls.change_choice(1) end
        end,
        desc = 'Snippet next choice',
      },
      {
        '<C-p>',
        function()
          if ls.choice_active() then ls.change_choice(-1) end
        end,
        desc = 'Snippet next choice',
      },
    })
  end
end

return M

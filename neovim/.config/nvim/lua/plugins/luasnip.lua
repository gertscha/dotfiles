local M = {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  run = 'make install_jsregexp',
  event = 'InsertEnter',
  depedencies = {
    'folke/which-key.nvim',
    'echasnovski/mini.icons', -- for the colors
  }
}

function M.config()
  local ls = require('luasnip')

  -- setup snippet loading
  local paths = {}
  table.insert(paths, vim.fn.stdpath('config') .. '/lua/snippets')
  -- require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load({ paths = paths })

  -- configure
  ls.config.setup({
    enable_autosnippets = false, -- currently I have no autosnippets, save performance
    keep_roots = true,           -- make it possible to resume a snippet
    update_events = { "TextChanged", "TextChangedI" },
  })

  -- add marker to choice nodes, seemingly there is no nice way to do it
  -- (ext_opts can do it, see commented section in the setup, the issue is
  -- that leaving insert mode does not remove the mark properly), solved with:
  -- https://github.com/L3MON4D3/LuaSnip/issues/937#issuecomment-2140050046
  local group = vim.api.nvim_create_augroup("UserLuasnip", { clear = true })
  local ns = vim.api.nvim_create_namespace("UserLuasnipNS")
  local function delete_extmarks()
    local extmarks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
    for _, extmark in ipairs(extmarks) do
      vim.api.nvim_buf_del_extmark(0, ns, extmark[1])
    end
  end
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LuasnipChoiceNodeEnter",
    callback = function()
      local node = require("luasnip").session.event_node
      local line = node:get_buf_position()[1]
      vim.api.nvim_buf_set_extmark(0, ns, line, -1, {
        end_line = line,
        end_right_gravity = true,
        right_gravity = false,
        virt_text = { { '◀ Choice Node', "Comment" } },
      })
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LuasnipChoiceNodeLeave",
    callback = delete_extmarks,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = delete_extmarks,
  })

  -- add keybinds
  local mod = P_require('which-key')
  if mod then
    mod.add({
      mode = { 'i', 's' },
      buffer = nil,   -- nil for Global mappings
      silent = true,  -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
      {
        '<C-s>',
        function()
          if ls.expand_or_jumpable()
          then
            ls.expand_or_jump()
          else
            vim.lsp.buf.signature_help()
          end
        end,
        desc = 'If available: "Snippet expand or jump", else "LSP signature help"'
      },
      {
        '<C-n>',
        function()
          if ls.choice_active() then ls.change_choice(1) end
        end,
        desc = 'Snippet next choice'
      },
      {
        '<C-p>',
        function() if ls.choice_active() then ls.change_choice(-1) end end,
        desc = 'Snippet next choice'
      },
    })
  end
end

return M

---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'L3MON4D3/LuaSnip', { version = 'v2.4.1' })
  end,
}

function M.config()
  -- load it eagerly
  -- could wait to call setup until a keybind is used
  -- but then completion won't show snippets until loaded
  local ls = require('luasnip')
  local types = require('luasnip.util.types')
  -- setup snippet loading
  local paths = {}
  table.insert(paths, vim.fn.stdpath('config') .. '/snippets')
  require('luasnip.loaders.from_lua').lazy_load({ paths = paths })
  -- require("luasnip.loaders.from_vscode").lazy_load()

  -- configure
  ls.setup({
    enable_autosnippets = false, -- currently I have no autosnippets, save performance
    keep_roots = false,
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
  -- cpp files use c snippets
  ls.filetype_extend('cpp', { 'c' })

  -- Unlink snippets when leaving insert mode
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      if
        require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
      then
        require('luasnip').unlink_current()
      end
    end,
  })

  -- add keybinds
  vim.keymap.set({ 'i', 's' }, '<C-s>', function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    else
      vim.lsp.buf.signature_help()
    end
  end, {
    silent = true,
    noremap = true,
    desc = '"Snippet expand or jump" or "LSP signature help"',
  })

  vim.keymap.set({ 'i', 's' }, '<C-n>', function()
    if ls.choice_active() then ls.change_choice(1) end
  end, { silent = true, noremap = true, desc = 'Snippet next choice' })

  vim.keymap.set({ 'i', 's' }, '<C-p>', function()
    if ls.choice_active() then ls.change_choice(-1) end
  end, { silent = true, noremap = true, desc = 'Snippet next choice' })
end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle LuaSnip jsregexp build',
  group = vim.api.nvim_create_augroup(
    'LuaSnip-pack-changed-install-handler',
    { clear = true }
  ),
  callback = function(event)
    if event.data.kind == 'install' then
      vim.notify('Installed LuaSnip, building jsregexp', vim.log.levels.INFO)
      -- lua snip jsregexp needs to be built
      local plugloc = vim.fn.stdpath('data') .. '/site/pack/core/opt/LuaSnip'
      vim.system(
        { 'make', 'install_jsregexp' },
        { cwd = plugloc, clear_env = true, stdin = '', stdout = false, text = true }
      )
    end
  end,
})

return M

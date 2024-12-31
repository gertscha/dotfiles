-- helper
local function prefix(desc)
  return 'Harpoon: ' .. desc
end

-- fast switching between buffers
local M = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  keys = {
    { '<leader>a', desc=prefix('Init & Add File') },
    { '<leader>h', desc=prefix('Init & Open List') },
    { '<leader>n', desc=prefix('Init & switch to 1') },
    { '<leader>m', desc=prefix('Init & switch to 2') },
    { '<leader>b', desc=prefix('Init & switch to 3') },
    { '<leader>v', desc=prefix('Init & switch to 4') },
    { '<C-k>', desc=prefix('Init & switch to previous') },
    { '<C-l>', desc=prefix('Init & switch to next') },
  },
}

function M.config()
  local harpoon = require('harpoon')
  harpoon:setup({
    settings = {
      save_on_toggle = true,
    },
  })

  -- this is the default
  local kopts = {
    mode = 'n', -- NORMAL mode
    prefix = '', -- the prefix is prepended to every mapping part of `mappings`
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }

  require('which-key').register({
    ['<leader>'] = {
      a = { function() harpoon:list():add() end, prefix('Add file') },
      h = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, prefix('Open List') },
      n = { function() harpoon:list():select(1) end, prefix('switch to 1') },
      m = { function() harpoon:list():select(2) end, prefix('switch to 2') },
      b = { function() harpoon:list():select(3) end, prefix('switch to 3') },
      v = { function() harpoon:list():select(4) end, prefix('switch to 4') },
    },
    ['<C-k>'] = { function() harpoon:list():prev() end, prefix('switch previous') },
    ['<C-l>'] = { function() harpoon:list():next() end, prefix('switch to next') },
  }, kopts)

end

return M


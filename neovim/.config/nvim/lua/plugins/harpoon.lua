---description helper
---@param desc string
---@return string
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
    { '<leader>a', desc = prefix('Init & Add File') },
    { '<leader>h', desc = prefix('Init & Open List') },
    { '<leader>m', desc = prefix('Init & switch to 1') },
    { '<leader>n', desc = prefix('Init & switch to 2') },
    { '<leader>b', desc = prefix('Init & switch to 3') },
    { '<leader>v', desc = prefix('Init & switch to 4') },
    { '<A-h>',     desc = prefix('Init & switch to previous') },
    { '<A-l>',     desc = prefix('Init & switch to next') },
  },
}

function M.config()
  local harpoon = require('harpoon')
  harpoon:setup({
    settings = {
      save_on_toggle = true,
    },
  })

  require('which-key').add({
    mode = 'n',     -- NORMAL mode
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>a', function() harpoon:list():add() end,                         desc = prefix('Add file') },
    { '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = prefix('Open List') },
    { '<leader>m', function() harpoon:list():select(1) end,                     desc = prefix('switch to 1') },
    { '<leader>n', function() harpoon:list():select(2) end,                     desc = prefix('switch to 2') },
    { '<leader>b', function() harpoon:list():select(3) end,                     desc = prefix('switch to 3') },
    { '<leader>v', function() harpoon:list():select(4) end,                     desc = prefix('switch to 4') },
    { '<A-h>',     function() harpoon:list():prev() end,                        desc = prefix('switch previous') },
    { '<A-l>',     function() harpoon:list():next() end,                        desc = prefix('switch to next') },
  })
end

return M

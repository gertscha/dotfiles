local M = {
  'brianhuster/live-preview.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  cmd = 'LivePreview',
  keys = {
    { '<leader>oms', desc = 'Markdown Preview start' },
    { '<leader>omp', desc = 'Markdown Preview pick' },
  }
}

function M.config()
  -- require('livepreview.config').set({
  --   port = 5500,
  --   browser = 'default',
  --   dynamic_root = false,
  --   sync_scroll = true,
  --   picker = "",
  -- })

  require('which-key').add({
    mode = 'n',     -- NORMAL mode
    buffer = nil,   -- nil for Global mappings. Give buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>oms', '<cmd>LivePreview start<cr>', desc = 'Markdown Preview start' },
    { '<leader>omc', '<cmd>LivePreview close<cr>', desc = 'Markdown Preview close' },
    { '<leader>omp', '<cmd>LivePreview pick<cr>',  desc = 'Markdown Preview pick' },
  })
end

return M

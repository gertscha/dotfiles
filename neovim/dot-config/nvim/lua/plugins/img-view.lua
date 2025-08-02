local M = {
  'img-view',
  dir = vim.fn.stdpath('config') .. '/custom/img-view.nvim',
  -- enabled = false,
  event = 'VeryLazy',
  config = function()
    local viewer = require('img-view')

    viewer:setup({
      -- filetypes = {
      --   jpg = false,
      -- },
    })

    vim.keymap.set('n', '<leader>tpc', function()
      -- viewer:paint_img()
      viewer:clean()
    end, { desc = 'Clear image' })
    vim.keymap.set('n', '<leader>tps', function()
      viewer:show_buf()
    end, { desc = 'Show image' })
  end,
}

return M

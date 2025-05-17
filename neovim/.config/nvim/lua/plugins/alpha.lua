-- a much simpler plugin:
-- return {
--   'eoh-bse/minintro.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('minintro').setup({ color = '#98c379' })
--   end,
-- }

-- start screen
local M = {
  'goolord/alpha-nvim',
  dependencies = {
    'echasnovski/mini.icons',
    -- 'folke/which-key.nvim',
  },
  lazy = false,
}

function M.config()
  local alphatheme = require('plugins.configuration.alpha_settings')
  require('alpha').setup(alphatheme.config)
  -- require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
  -- require('which-key').add({
  --   { '<leader>os', '<cmd>Alpha<cr>', desc = '[O]pen [S]plash Screen' },
  -- })
  vim.keymap.set(
    'n',
    '<leader>os',
    '<cmd>Alpha<cr>',
    { desc = '[O]pen [S]plash Screen' }
  )
end

return M

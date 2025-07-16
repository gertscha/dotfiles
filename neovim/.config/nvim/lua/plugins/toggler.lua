local M = {
  'nvim-toggler', -- fork of: 'nguyenvukhang/nvim-toggler'
  dir = vim.fn.stdpath('config') .. '/custom/nvim-toggler',
  event = 'User my.lazy.trigger',
  opts = {
    inverses = {
      ['true'] = 'false',
      ['True'] = 'False',
      ['TRUE'] = 'FALSE',
      ['yes'] = 'no',
      ['on'] = 'off',
      ['left'] = 'right',
      ['up'] = 'down',
      ['enable'] = 'disable',
      ['!='] = '==',
      ['<'] = '>=',
      ['>'] = '<=',
    },
    remove_default_keybinds = false,
    remove_default_inverses = false,
    autoselect_longest_match = true,
  },
}

return M

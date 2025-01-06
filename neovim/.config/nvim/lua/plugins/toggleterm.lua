-- terminal overlay that can be toggled
local M = {
  'akinsho/toggleterm.nvim',
  cmd = 'Toggleterm',
  keys = {
    { '<leader>ot', '<cmd>Toggleterm open<cr>', desc = 'Toggle/[O]pen [T]erminal' },
  },
  opts = {
    size = 15,
    open_mapping = [[<leader>ot]],
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = false,  -- if true, the mapping will also take effect in insert model.
    terminal_mappings = true, -- if true, the mappings take effect in the opened terminal.
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    auto_scroll = true,
    shell = vim.o.shell,
    float_opts = {
      width = vim.o.columns,
      height = function() return math.floor(vim.o.lines * 0.95) end,
      row = -1,
      zindex = 90,
      winblend = 0,
    },
  },
}

return M

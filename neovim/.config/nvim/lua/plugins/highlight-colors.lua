local M = {
  'brenoprata10/nvim-highlight-colors',
  cmd = { 'HighlightColors' },
  keys = {
    { '<leader>tc', desc = 'Toggle color visualization' },
  },
  dependencies = {
    'folke/which-key.nvim',
  },
}

function M.config()
  local hlc = require('nvim-highlight-colors')
  hlc.setup({
    render = 'background', -- 'background'|'foreground'|'virtual'

    enable_hex = true, -- hex, e.g. '#FFFFFF'
    enable_short_hex = false, -- short hex  e.g. '#fff'
    enable_rgb = true, -- rgb , e.g. 'rgb(0 0 0)'
    enable_hsl = true, -- hsl , e.g. 'hsl(150deg 30% 40%)'
    enable_hsl_without_function = false, -- e.g. --foreground: 0 69% 69%;
    enable_ansi = true, -- ansi , e.g '\033[0;34m'
    enable_var_usage = true, -- CSS, e.g. 'var(--testing-color)'
    enable_named_ = false, -- named colors, e.g. 'green'
    enable_tailwind = false, -- tailwind , e.g. 'bg-blue-500'

    -- Exclude filetypes or buftypes from highlighting
    exclude_filetypes = {},
    exclude_buftypes = {},
  })
  hlc.toggle() -- turn on, needed if loaded due to keybind

  require('which-key').add({
    mode = 'n', -- NORMAL mode
    buffer = nil, -- nil for Global mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    {
      '<leader>tc',
      '<cmd>HighlightColors Toggle<cr>',
      desc = 'Toggle color visualization',
    },
  })
end

return M

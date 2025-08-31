---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(
      spec,
      'brenoprata10/nvim-highlight-colors',
      { version = 'b42a5ccec7457b44e89f7ed3b3afb1b375bb2093' }
    )
  end,
}

function M.config()
  local setupdone = false
  local function setuphlc()
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
    hlc.toggle() -- turn on, otherwise first toggle won't work
    setupdone = true
  end

  vim.keymap.set('n', '<leader>tc', function()
    if not setupdone then setuphlc() end
    vim.cmd.HighlightColors('Toggle')
  end, { noremap = true, desc = 'Toggle color visualization' })
end

return M

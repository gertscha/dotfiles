---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'nvim-mini/mini.ai', {
      version = 'stable',
    })
    Add_plugin(spec, 'nvim-mini/mini.surround', {
      version = 'stable',
    })
    -- mini.icons is setup in base.lua
  end,
}

function M.config()
  -- Extend and create a/i textobjects
  -- mainly use b (brace), q (quotes), f (function) and sometimes ? is good
  local mai = P_require('mini.ai', true)
  if mai then
    mai.setup({
      mappings = {
        around = 'a',
        inside = 'i',
        -- Disable these to keep the built-in LSP selection mappings on Neovim>=0.12
        -- an and in in visual mode
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',
        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
      },
    })
  end

  -- modify surrounding objects like quotes
  local msr = P_require('mini.surround', true)
  if msr then
    msr.setup({
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    })
  end
end

return M

---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'echasnovski/mini.ai', {
      version = 'stable',
    })
    Add_plugin(spec, 'echasnovski/mini.surround', {
      version = 'stable',
    })
    -- mini.icons is setup in base.lua
  end,
}

function M.config()
  -- Extend and create a/i textobjects
  -- mainly use b (brace), q (quotes), f (function) and sometimes ? is good
  require('mini.ai').setup({
    mappings = {
      around = 'a',
      inside = 'i',
      -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
      -- Map LSP selection manually to use it (see `:h MiniAi.config`)
      around_next = 'an',
      inside_next = 'in',
      around_last = 'al',
      inside_last = 'il',
      -- Move cursor to corresponding edge of `a` textobject
      goto_left = 'g[',
      goto_right = 'g]',
    },
  })

  -- modify surrounding objects like quotes
  require('mini.surround').setup({
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

return M

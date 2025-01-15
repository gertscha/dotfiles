local M = {
  'marko-cerovac/material.nvim',
  lazy = false,
  priority = 1000,
}

function M.config()
  require('material').setup({
    contrast = {
      terminal = false,            -- Enable contrast for the built-in terminal
      sidebars = false,            -- Enable contrast for sidebar-like windows
      floating_windows = false,    -- Enable contrast for floating windows
      cursor_line = false,         -- Enable darker background for the cursor line
      non_current_windows = false, -- Enable contrasted background for non-current windows
      filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
    },
    styles = {                     -- Give comments style such as bold, italic, underline etc.
      comments = { italic = true },
      strings = { --[[ bold = true ]] },
      keywords = { --[[ underline = true ]] },
      functions = { --[[ bold = true, undercurl = true ]] },
      variables = {},
      operators = {},
      types = {},
    },
    plugins = { -- Uncomment the plugins that you use to highlight them
      'gitsigns',
      'harpoon',
      'mini',
      'telescope',
      'which-key',
      -- 'dap',
      -- 'trouble',
      -- 'nvim-cmp',
      -- 'nvim-navic',
      -- 'nvim-tree',
      -- 'nvim-web-devicons',
    },
    disable = {
      colored_cursor = true, -- Disable the colored cursor
      borders = true,        -- Disable borders between verticaly split windows
      background = true,     -- Prevent the theme from setting the background
      term_colors = false,   -- Prevent the theme from setting terminal colors
      eob_lines = false      -- Hide the end-of-buffer lines
    },
    high_visibility = {
      lighter = false, -- Enable higher contrast text for lighter style
      darker = false   -- Enable higher contrast text for darker style
    },

    lualine_style = 'stealth', -- Lualine style ( can be 'stealth' or 'default' )
    async_loading = true,      -- Load parts of the theme asyncronously
  })

  -- There are 5 different styles available:
  -- 'darker', 'lighter', 'oceanic', 'palenight', 'deep ocean'
  vim.g.material_style = 'darker'
  vim.cmd 'colorscheme material'

  -- command toggle style selection ui
  -- :lua require('material.functions').find_style()
end

return M

-- helper function, taken from the lualine.nvim wiki
--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.o.columns
    if hide_width and win_width < hide_width then
      return ''
    elseif
      trunc_width
      and trunc_len
      and win_width < trunc_width
      and #str > trunc_len
    then
      return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

-- Used for shortening Mode in smaller terminals
local mode_map = {
  ['NORMAL'] = 'N',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-LINE'] = 'VL',
  ['V-BLOCK'] = 'VB',
  ['COMMAND'] = 'C',
  ['TERMINAL'] = 'T',
  ['REPLACE'] = 'R',
}

local function formatMode(str)
  if vim.o.columns < 87 then return mode_map[str] or str end
  return str
end

-- status line at the bottom of the buffers
local M = {
  'nvim-lualine/lualine.nvim',
  event = { 'BufRead', 'BufNewFile' },
  -- lazy passes a table argument to the config function of the plugin
  opts = {
    options = {
      icons_enabled = true,
      theme = 'iceberg_dark',
      component_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {
          'alpha',
          'fugitive',
          'undotree',
          'oil',
        },
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = false,
      globalstatus = false,
      refresh = {
        statusline = 300,
        tabline = 800,
        winbar = 800,
      },
    },
    sections = {
      lualine_a = { { 'mode', fmt = formatMode, padding = 1 } },
      lualine_b = {
        { 'branch', fmt = trunc(0, 0, 60, true) },
        { 'diff', fmt = trunc(0, 0, 110, true) },
        { 'diagnostics' },
        { 'selectioncount', fmt = trunc(0, 0, 120, true) },
        -- { window, fmt=trunc(0, 0, 60, true) },
      },
      lualine_c = {
        {
          'filename',
          file_status = false,
          path = 3,
          symbols = {
            unnamed = '[Unnamed]',
            newfile = '[New]',
          },
          shorting_target = 55,
        },
      },
      lualine_x = {
        { 'datetime', style = '%H:%M', fmt = trunc(0, 0, 120, true) },
        -- {'datetime', style = '%a, %d/%m/%Y', fmt=trunc(0, 0, 140, true)},
        -- {'fileformat', fmt=trunc(0, 0, 140, true)},
        { 'encoding', fmt = trunc(0, 0, 140, true) },
      },
      lualine_y = {
        { 'filetype', fmt = trunc(0, 0, 45, true) },
        { 'progress', fmt = trunc(0, 0, 55, true) },
      },
      lualine_z = {
        {
          'location',
          -- default color is 'lualine_a_normal' (a highlight group)
          -- this is the same but not bold (for theme 'iceberg_dark')
          color = { gui = 'nocombine', guifg = '#17171b', guibg = '#818596' },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
}

return M

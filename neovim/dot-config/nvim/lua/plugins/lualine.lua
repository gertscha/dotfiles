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

-- lsp progress spinner, inspired by:
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
-- but adjusted to show status spinner in lualine instead
local spinner =
  { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local spinner_pos = 1
local lsp_has_progress = false
-- autocommand to detect lsp status changes, spinner shown with status_info()
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= 'table' then return end
    if value.kind == 'begin' or value.kind == 'report' then
      lsp_has_progress = true
    elseif value.kind == 'end' then
      lsp_has_progress = false
    else
      vim.notify('LSP progress error (lualine.lua)', vim.log.levels.ERROR)
    end
  end,
})

local function status_info()
  -- Obsession.vim: [$] -> on and [S] -> off
  local ses_st = vim.fn.ObsessionStatus()
  local ses_icon = '󰅖'
  if ses_st == '[$]' then ses_icon = '' end

  -- LSP, returns a list of attached servers for the current buffer, take length
  local lsp_st = #(vim.lsp.get_clients({ bufnr = 0 }))
  local lsp_icon = '󰅖'
  if lsp_st > 0 then
    if lsp_has_progress then
      spinner_pos = math.fmod(spinner_pos + 1, #spinner) + 1 -- one indexed
      lsp_icon = spinner[spinner_pos]
    else
      lsp_icon = ''
    end
  end

  return string.format(' %s  %s', ses_icon, lsp_icon)
end

-- status line at the bottom of the buffers
local M = {
  'nvim-lualine/lualine.nvim',
  event = 'User my.lazy.trigger',
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
          'snacks_dashboard',
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
        statusline = 1000,
        tabline = 5000,
        winbar = 5000,
        refresh_time = 41, -- 24 FPS
        -- events = {
        --   'LspProgress',
        -- },
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
        -- { 'datetime', style = '%H:%M', fmt = trunc(0, 0, 120, true) },
        -- { 'datetime', style = '%a, %d/%m/%Y', fmt = trunc(0, 0, 140, true) },
        -- { 'fileformat', fmt = trunc(0, 0, 140, true) },
        -- { 'encoding', fmt = trunc(0, 0, 140, true) },
        { 'filetype', fmt = trunc(0, 0, 45, true) },
        { status_info },
      },
      lualine_y = {
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

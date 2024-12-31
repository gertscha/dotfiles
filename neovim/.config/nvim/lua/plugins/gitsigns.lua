local M = {
  'lewis6991/gitsigns.nvim',
  tag = 'v0.7',
  event = { 'BufRead', 'BufNewFile' },
  cmd = 'Gitsigns',
}

function M.config()
  local icons = require 'settings.icons'
  require('gitsigns').setup {
    signs = {
      add = {
        hl = 'GitSignsAdd',
        text = icons.ui.BoldLineMiddle,
        numhl = 'GitSignsAddNr',
        linehl = 'GitSignsAddLn', },
      change = {
        hl = 'GitSignsChange',
        text = icons.ui.BoldLineDashedMiddle,
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn', },
      delete = {
        hl = 'GitSignsDelete',
        text = icons.ui.TriangleShortArrowRight,
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn', },
      topdelete = {
        hl = 'GitSignsDelete',
        text = icons.ui.TriangleShortArrowRight,
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn', },
      changedelete = {
        hl = 'GitSignsChange',
        text = icons.ui.BoldLineMiddle,
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn', },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 3000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { interval = 2000, follow_files = true },
    attach_to_untracked = false,
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    yadm = { enable = false },
  }
end

return M


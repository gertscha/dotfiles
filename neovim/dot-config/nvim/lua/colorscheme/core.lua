-- This was based on:
--   https://github.com/y9san9/fangcs.nvim
--   by Alex Sokol
--
-- code structure was inspired by:
--   https://github.com/folke/tokyonight.nvim
--   and
--   https://github.com/vague-theme/vague.nvim
--
-- and theme idea was motivated by the Alabaster theme:
--   https://tonsky.me/blog/syntax-highlighting/

---@class FangTermColors
---@field black string
---@field black_bright string
---@field white string
---@field white_bright string
---@field red string
---@field red_bright string
---@field green string
---@field green_bright string
---@field yellow string
---@field yellow_bright string
---@field blue string
---@field blue_bright string
---@field purple string
---@field purple_bright string
---@field cyan string
---@field cyan_bright string

---@class FangBaseColors
---@field bgc string
---@field fgc string
---@field primary string
---@field secondary string
---@field muted string
---@field comment string
---@field red string
---@field yellow string
---@field green string

---@class FangColorScheme
---@field transparent boolean
---@field base FangBaseColors
---@field term FangTermColors
---@field bgc_hi string
---@field bgc_hi_bright string
---@field primary_bgc string
---@field secondary_bgc string
---@field deemphasize string
---@field muted_bgc string
---@field green_bgc string
---@field hint string
---@field error string
---@field warning string
---@field information string

local M = {}

---@param theme FangColorScheme
--- Apply the colorscheme in the argument
M.apply = function(theme)
  vim.o.termguicolors = true
  vim.g.colors_name = 'fang'

  local groups = require('colorscheme.groups').load_groups(theme)

  vim.cmd('hi clear')

  for _, group in pairs(groups) do
    for higroup, hiset in pairs(group) do
      local spec = type(hiset) == 'string' and { link = hiset } or hiset
      ---@cast spec table
      vim.api.nvim_set_hl(0, higroup, spec)
    end
  end
end

---@param colors FangBaseColors
---@param term_colors FangTermColors
---@param transparent boolean
--- Define/Derive the base colors from the input base colors and call apply()
--- to set the all the highlights
M.set = function(colors, term_colors, transparent)
  local prim = require('colorscheme.primitives')
  local is_dark = vim.o.background == 'dark'

  ---@type FangColorScheme
  local t = { ---@diagnostic disable-line:missing-fields
    transparent = transparent,
    base = colors,
    term = term_colors,
  }

  -- =========================
  -- Compute colors
  -- =========================

  t.deemphasize = prim.mix(t.base.muted, t.base.fgc, is_dark and 0.4 or 0.1)

  t.bgc_hi = prim.adjust_hsl(t.base.bgc, 0, 0, is_dark and 0.08 or -0.08)

  t.bgc_hi_bright = prim.adjust_hsl(t.base.bgc, 0, 0, is_dark and 0.25 or -0.3)

  t.primary_bgc = prim.mix(t.base.primary, t.base.bgc, is_dark and 0.35 or 0.50)

  t.secondary_bgc = prim.mix(t.base.secondary, t.base.bgc, is_dark and 0.25 or 0.50)

  t.muted_bgc = prim.mix(t.base.muted, t.base.bgc, is_dark and 0.75 or 0.80)

  t.green_bgc = prim.mix(t.base.green, t.base.bgc, is_dark and 0.5 or 0.80)

  -- =========================
  -- Diagnostics
  -- =========================

  t.error = t.base.red
  t.warning = t.base.yellow
  t.information = t.base.muted
  t.hint = t.deemphasize

  -- =========================
  -- Terminal colors
  -- =========================

  -- dark
  vim.g.terminal_color_0 = t.term.black
  vim.g.terminal_color_8 = t.term.black_bright
    or prim.adjust_hsl(t.term.black_bright, 0, 0, is_dark and 0.35 or 0.25)
  -- light
  vim.g.terminal_color_7 = t.term.white
  vim.g.terminal_color_15 = t.term.white_bright
    or prim.adjust_hsl(t.term.white_bright, 0, 0, is_dark and -0.25 or 0.25)
  -- colors
  vim.g.terminal_color_1 = t.term.red
  vim.g.terminal_color_9 = t.term.red_bright
  vim.g.terminal_color_2 = t.term.green
  vim.g.terminal_color_10 = t.term.green_bright
  vim.g.terminal_color_3 = t.term.yellow
  vim.g.terminal_color_11 = t.term.yellow_bright
  vim.g.terminal_color_4 = t.term.blue
  vim.g.terminal_color_12 = t.term.blue_bright
  vim.g.terminal_color_5 = t.term.purple
  vim.g.terminal_color_13 = t.term.purple_bright
  vim.g.terminal_color_6 = t.term.cyan
  vim.g.terminal_color_14 = t.term.cyan_bright

  -- =========================
  -- Apply it
  -- =========================

  M.apply(t)
end

return M

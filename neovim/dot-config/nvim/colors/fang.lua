-- Use the core code to define a colorscheme based on just the color definitons
-- given here
--
-- the color palatte is based on the vague theme
--   https://github.com/vague-theme

-- vague theme terminal colors (directly copied)
local term_colors = {
  black = '#252530',
  black_bright = '#606079',
  white = '#cdcdcd',
  white_bright = '#d7d7d7',
  red = '#d8647e',
  red_bright = '#e08398',
  green = '#7fa563',
  green_bright = '#99b782',
  yellow = '#f3be7c',
  yellow_bright = '#f5cb96',
  blue = '#6e94b2',
  blue_bright = '#8ba9c1',
  purple = '#bb9dbd',
  purple_bright = '#c9b1ca',
  cyan = '#aeaed1',
  cyan_bright = '#bebeda',
}

-- dark and light theme config (mostly the two are the same)
-- (just a selection of vague colors)
local theme
if vim.o.background == 'light' then
  theme = {
    bgc = '#f7f7f7',
    fgc = '#111111',
    primary = '#6e94b2',
    secondary = '#f3be7c',
    muted = '#aaaaaa',
    comment = '#7fa563',

    red = '#d8647e',
    yellow = '#f3be7c',
    green = '#7fa563',
  }
else
  theme = {
    bgc = '#141415',
    fgc = '#cdcdcd',
    primary = '#6e94b2',
    secondary = '#f3be7c',
    comment = '#7fa563',
    muted = '#606079',

    red = '#d8647e',
    yellow = '#f3be7c',
    green = '#7fa563',
  }
end

local transparent = true

local core = require('colorscheme.core')
core.set(theme, term_colors, transparent)

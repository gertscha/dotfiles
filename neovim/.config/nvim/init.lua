-- My Neovim Config
-- inspired by TJ DeVries and Christian Chiarulli

-- some filetype specific settings get auto run see the files in
-- 'after/ftplugin' and :help ftplugin for more info

-- protected require
function P_require(m)
  local ok, err = pcall(require, m)
  if not ok then return nil, err end
  return err
end

require 'settings.options'  -- base nvim settings
require 'settings.keybinds' -- keybind adjustments
require 'settings.autocmds' -- event based actions
require 'settings.lazy'     -- the plugin manager (also loads the plugins)


-- make some nicer labels
local mod = P_require('which-key')
if mod then
  mod.add({
    mode = 'n', -- NORMAL mode
    { '<space>l',   group = 'Session Managment' },
    { '<space>ll',  group = 'Special Sessions' },
    { '<space>llg', group = 'Load/Get Special Sessions' },
    { '<space>lls', group = 'Save Special Sessions' },
    { '<space>o',   group = 'Open Screens' },
    { '<space>om',  group = 'Markdown' },
    { '<space>t',   group = 'Toggle' },
    { '<space>tw',  group = 'Line width settings' },
    { '<space>w',   group = 'Move words' },
    { '<space>y',   group = 'Yank' },
  })
end

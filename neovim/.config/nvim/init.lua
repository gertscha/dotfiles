-- My Neovim Config
-- inspired by TJ DeVries and Christian Chiarulli

-- some filetype specific settings get auto run see the files in
-- 'after/ftplugin' and :help ftplugin for more info

---protected require
---@param module string
---@return table?
function P_require(module)
  local ok, m = pcall(require, module)
  if not ok then print('P_rquire error: ' .. m) return nil end
  return m
end

require 'settings.options'  -- base nvim settings
require 'settings.keybinds' -- keybind adjustments
require 'settings.autocmds' -- event based actions
require 'settings.lazy'     -- the plugin manager (also loads the plugins)


-- make some nicer labels for which-key
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
    { '<space>y',   group = 'Yank' },
  })
end

-- My Neovim Config
-- inspired by TJ DeVries and Christian Chiarulli

-- some filetype specific settings get auto run see the files in
-- 'after/ftplugin' and :help ftplugin for more info

require 'settings.options'  -- base nvim settings
require 'settings.keybinds' -- keybind adjustments
require 'settings.autocmds' -- event based actions
require 'settings.lazy'     -- the plugin manager (also loads the plugins)

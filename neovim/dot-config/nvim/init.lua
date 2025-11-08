-- My Neovim Config
-- early versions inspired by TJ DeVries and Christian Chiarulli
-- Kickstart.nvim is also a great resource

-- Globals
SessionSaveFile = 'Session.vim~'

require('settings.options') -- base nvim settings
require('settings.keybinds') -- keybind adjustments
require('settings.autocmds') -- event based actions
require('template.commands') -- commands to generate template files

-- Load plugins (using vim.pack)
require('plugin-manager')

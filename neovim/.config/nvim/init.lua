-- My Neovim Config
-- inspired by TJ DeVries and Christian Chiarulli

-- table for all the lazy plugin specs
LAZY_PLUGIN_SPEC = {}

-- function to add specs to the table
local function add_plugin(plugin_config)
  table.insert(LAZY_PLUGIN_SPEC, { import = plugin_config })
end


-- some filetype specific settings get auto run
-- see the files in 'after/ftplugin' and :help ftplugin
require 'settings.options' -- vim settings
require 'settings.keybinds' -- keybind adjustments
require 'settings.autocmds' -- event based actions
add_plugin 'user.colorscheme' -- color scheme config
add_plugin 'user.devicons' -- icons
add_plugin 'user.cmp' -- autocompletion
add_plugin 'user.oil' -- filemanagement
add_plugin 'user.move' -- move lines around
add_plugin 'user.which-key' -- keybind guide
add_plugin 'user.lualine' -- bottom status line
add_plugin 'user.alpha' -- splash screen
add_plugin 'user.undotree' -- view undo history with branches
add_plugin 'user.harpoon' -- file switcher
add_plugin 'user.treesitter' -- syntax tree access, also shows code context
add_plugin 'user.fugitive' -- git integration
add_plugin 'user.telescope' -- fuzzy finder
add_plugin 'user.gitsigns' -- git line markings
add_plugin 'user.lspconfig' -- lsp setup and config
add_plugin 'user.autopairs' -- create closing braces/quotes/etc
add_plugin 'user.toggleterm' -- floating terminal
add_plugin 'user.dap' -- debugging
-- add_plugin 'user.schemastore' -- no config file yet
-- add_plugin' user.ufo' -- no config file yet
-- add_plugin' user.neotab' -- no config file yet

require 'user.lazy' -- the plugin manager

